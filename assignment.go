package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

var (
	logFile, _    = os.OpenFile("/var/log/gologs/app.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	infoLogger    = log.New(logFile, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile)
	warnLogger    = log.New(logFile, "WARN: ", log.Ldate|log.Ltime|log.Lshortfile)
	debugLogger   = log.New(logFile, "DEBUG: ", log.Ldate|log.Ltime|log.Lshortfile)
	errorLogger   = log.New(logFile, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile)
)

func logHandler(w http.ResponseWriter, r *http.Request) {
	level := r.URL.Query().Get("level")
	message := r.URL.Query().Get("message")

	switch level {
	case "info":
		infoLogger.Println(message)
	case "warn":
		warnLogger.Println(message)
	case "debug":
		debugLogger.Println(message)
	case "error":
		errorLogger.Println(message)
	default:
		http.Error(w, "Invalid log level", http.StatusBadRequest)
		return
	}

	fmt.Fprintf(w, "Logged %s: %s", level, message)
}

func main() {
	defer logFile.Close()
	http.HandleFunc("/log", logHandler)
	log.Println("Starting log service on port 8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}
