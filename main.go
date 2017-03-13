package main

import (
	"context"
	"flag"
	"log"
	"net/http"
	"os"
	"os/exec"

	"github.com/stuartnelson3/guac"
)

func main() {
	var (
		port  = flag.String("port", "8080", "port to listen on")
		dev   = flag.Bool("dev", true, "enable code rebuilding")
		debug = flag.Bool("debug", false, "enable elm debugger")
	)
	flag.Parse()

	http.HandleFunc("/script.js", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "script.js")
	})

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "index.html")
	})

	if *dev {
		// Recompile the elm code whenever a change is detected.
		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()

		const elmMake = "elm-make"
		elmMakeArgs := []string{"src/Main.elm", "--output", "script.js"}

		if *debug {
			elmMakeArgs = append(elmMakeArgs, "--debug")
		}

		recompileFn := func() error {
			cmd := exec.Command(elmMake, elmMakeArgs...)
			cmd.Stdout = os.Stdout
			cmd.Stderr = os.Stderr
			return cmd.Run()
		}

		go recompileFn()

		watcher, err := guac.NewWatcher(ctx, "./src", recompileFn)
		if err != nil {
			log.Fatalf("error watching: %v", err)
		}
		go watcher.Run()
	}

	log.Printf("starting listener on port %s", *port)
	if err := http.ListenAndServe(":"+*port, nil); err != nil {
		log.Fatal(err)
	}
}
