var express= require ("express");
var app = express();

app.get("/url",(req,res,next) => {
res.json({"message":"Automate all the things - Amazing!","timestamp":Math.floor(Date.now() / 1000)});
});


module.exports = app;
