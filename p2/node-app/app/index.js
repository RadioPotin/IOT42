const express = require('express')

const app = express()
const port = 8000

app.get('/', (req, res) => {
    res.sendFile('/home.html', {
        root: __dirname
    })
})

app.listen(port, () => {
  console.log(`Listening on port :${port}`)
})
