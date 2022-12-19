const express = require('express')

const app = express()
const port = 80

app.get('/', (req, res) => {
    res.sendFile('/home.html', {
        root: __dirname
    })
})

app.get('/500', (req, res) => {
  process.exit(1)
})

app.listen(port, () => {
  console.log(`node-app listening on port :${port}`)
})
