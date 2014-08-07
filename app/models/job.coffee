# app/models/job.coffee

mongoose   = require('mongoose')
Schema     = mongoose.Schema

JobSchema  = new Schema
  title: String
  company: String
  salary: Number

module.exports = mongoose.model('Job', JobSchema)
