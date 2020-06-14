const express = require('express');
const app = express();
const port = 5000;

// read API keys from file
const fs = require("fs");
const API_keys = JSON.parse(fs.readFileSync('API-KEY.txt').toString());
const Guardian_key = API_keys.Guardian;

// enable CORS
const cors = require('cors');
app.use(cors());

// routers
const axios = require('axios');

// google trends api
const googleTrends = require('google-trends-api');

function getFormatTime(utcStr) {
    const pubDate = new Date(utcStr);
    const current = new Date();
    const diff = current.getTime() - pubDate.getTime();
    if (diff >= 60 * 60 * 1000)
        return parseInt(diff / (60 * 60 * 1000)) + "h";
    else if (diff >= 60 * 1000)
        return parseInt(diff / (60 * 1000)) + "m";
    else
        return parseInt(diff / 1000) + "s";
}

const monthAbbr = ["Jan", "Feb", "Mar", "Apr", "May", "June",
                 "July", "Aug", "Sept", "Oct", "Nov", "Dec"];

function getFormateDate(utcStr) {
    const pubDate = new Date(utcStr);
    const date = pubDate.getDate();
    const month = pubDate.getMonth();

    let resStr = "";
    if (date < 10)
        resStr += "0";
    resStr += date + " ";
    resStr += monthAbbr[month] + " ";
    resStr += pubDate.getFullYear() + "";

    return resStr;
}

function getGuardianImage(obj) {
    if (obj.blocks.main !== undefined) {
        let assets = obj.blocks.main.elements[0].assets;
        if (assets.length !== 0) {
            return assets[assets.length - 1].file;
        }
    }
    return "";
}

function getThumbnailImage(obj) {
    if (obj.fields === undefined || obj.fields.thumbnail === undefined) {
        return "";
    }
    else {
        return obj.fields.thumbnail;
    }
}

function handleHomeResult(result) {
    let news_arr = [];
    for (let res_obj of result.data.response.results) {

        // number of news should not exceed limit
        if (news_arr.length >= 10) {
            break;
        }

        let news_obj = {
            image: getThumbnailImage(res_obj),
            title: res_obj.webTitle,
            time: getFormatTime(res_obj.webPublicationDate),
            date: getFormateDate(res_obj.webPublicationDate),
            section: res_obj.sectionName,
            id: res_obj.id,
            webUrl: res_obj.webUrl
        };

        news_arr.push(news_obj);
    }
    return news_arr;
}

function handleSearchResult(result) {
    let news_arr = [];
    for (let res_obj of result.data.response.results) {
        // number of news should not exceed limit
        if (news_arr.length >= 10) {
            break;
        }
        
        let news_obj = {
            image: getGuardianImage(res_obj),
            title: res_obj.webTitle,
            time: getFormatTime(res_obj.webPublicationDate),
            date: getFormateDate(res_obj.webPublicationDate),
            section: res_obj.sectionName,
            id: res_obj.id,
            webUrl: res_obj.webUrl
        };

        news_arr.push(news_obj);
    }
    return news_arr;
}

function handleDetailResult(result) {
    const content = result.data.response.content;

    return {
        title: content.webTitle,
        image: getGuardianImage(content),
        description: content.blocks.body[0].bodyTextSummary,
        date: getFormateDate(content.webPublicationDate)
    };
}

app.get('/guardian/home', (req, res) => {
    axios.get('https://content.guardianapis.com/search', {
        params: {
            'api-key': Guardian_key,
            'orderby': 'newest',
            'show-fields': 'starRating,headline,thumbnail,short-url'
        }
    })
        .then(result => {
            let news_arr = handleHomeResult(result);
            res.send({"news_arr": news_arr});
        })
        .catch(error => {
            res.send(error);
        })
});

app.get('/guardian/detail', (req, res) => {
    let id = req.query.id;

    axios.get('https://content.guardianapis.com/' + id, {
        params: {
            'api-key': Guardian_key,
            'show-blocks': 'all'
        }
    })
        .then(result => {
            let news_detail = handleDetailResult(result);
            res.send({"news_detail": news_detail});
        })
        .catch(error => {
            res.send(error);
        })
});

app.get('/guardian/search', (req, res) => {
    let keyword = req.query.keyword;

    axios.get('https://content.guardianapis.com/search', {
        params: {
            'q': keyword,
            'api-key': Guardian_key,
            'show-blocks': 'all'
        }
    })
        .then(result => {
            let search_arr = handleSearchResult(result);
            res.send({"news_arr": search_arr});
        })
        .catch(error => {
            res.send(error);
        })
})

app.get('/trends', (req, res) => {
    let keyword = req.query.keyword;

    googleTrends.interestOverTime({keyword: keyword, startTime: new Date(2019, 5, 1)})
                .then(result => {
                    let trends_data = JSON.parse(result).default.timelineData
                    .map(obj => obj.value[0]);
                    res.send({"trends_data": trends_data});
                })
                .catch(error => {
                    res.send(error);
                })
})

app.get('/guardian/section', (req, res) => {
    let section = req.query.sectionName;

    axios.get('https://content.guardianapis.com/' + section, {
        params: {
            'api-key': Guardian_key,
            'show-blocks': 'all'
        }
    })
        .then(result => {
            let news_arr = handleSearchResult(result);
            res.send({"news_arr": news_arr});
        })
        .catch(error => {
            res.send(error);
        })
});

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`));
