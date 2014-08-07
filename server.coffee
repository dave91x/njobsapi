# server.coffee

# BASE SETUP
# ============================================
express    = require('express')
app        = express()
bodyParser = require('body-parser')
mongoose   = require('mongoose')

appConfig = require('./config/app_config.js')

# connect to the database
mongoose.connect(appConfig.url)

# define/declare model(s)
Job = require('./app/models/job')

app.use(bodyParser.json())
app.use(bodyParser.urlencoded( { extended: true } ))

port = process.env.PORT || 8000

# ROUTES FOR API
# ============================================
router = express.Router()

# middleware to use for all requests
router.use (req, res, next) ->
  # do logging here
  console.log('Something is happening in the middleware layer right now...')
  next() # make sure we go to the next route and not stop here!

# initial basic route
router.get '/', (req, res) ->
  res.json { message: 'Welcome to the jobs API!' }

# define routes that end in /jobs
router.route('/jobs').post( (req, res) ->
  job = new Job()
  job.title   = req.body.title
  job.company = req.body.company
  job.salary  = req.body.salary
  
  job.save( (err) ->
    res.send(err) if err
    res.json { message: 'Job opening created!' }
  )
).get( (req, res) ->
  Job.find (err, jobs) ->
    res.send(err) if err
    res.json(jobs)
)

# define routes that end in /jobs/:job_id
router.route('/jobs/:job_id').get( (req, res) ->
  # get the job with the specified ID
  Job.findById(req.params.job_id, (err, job) ->
    res.send(err) if err
    res.json(job)
  )
).put( (req, res) ->
  Job.findById(req.params.job_id, (err, job) ->
    res.send(err) if err
    job.title   = req.body.title   if req.body.title
    job.company = req.body.company if req.body.company
    job.salary  = req.body.salary  if req.body.salary
    
    job.save( (err) ->
      res.send(err) if err
      res.json { message: 'Job listing has been updated!' }
    )
  )
).delete( (req, res) ->
  Job.remove( { _id: req.params.job_id }, (err, job) ->
    res.send(err) if err
    res.json { message: 'Job listing deleted successfully!' }
  )
)

# REGISTER THE ROUTES
# ============================================
# all the routes will be prefixed with /api
app.use('/api', router)

# START THE SERVER
# ============================================
app.listen(port)
console.log('The magic happens on port ' + port)

