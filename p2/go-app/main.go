package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {

	homePage := func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "home.html")
	}

	http.HandleFunc("/", homePage)
	
	fmt.Println("Listening on port :8000")
	log.Fatal(http.ListenAndServe(":8000", nil))
}
