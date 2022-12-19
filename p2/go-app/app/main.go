package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {

	homePage := func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "home.html")
	}

	errorPage := func(w http.ResponseWriter, r *http.Request) {
		os.Exit(1)
	}

	http.HandleFunc("/", homePage)

	http.HandleFunc("/500", errorPage)
	
	fmt.Println("go-app listening on port :80")
	log.Fatal(http.ListenAndServe(":80", nil))
}
