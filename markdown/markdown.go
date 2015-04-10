package main

import (
	"bytes"
	"io"
	"flag"
	"fmt"
	"github.com/russross/blackfriday"
	"os"
	"strings"
)

func main() {
	fileName := flag.String("filename", "", "The filename to parse.")
	outDir := flag.String("outdir", "", "The directory to write the output to.")
	flag.Parse()

	if len(*fileName) > 0 {
		file, err := os.Open(*fileName)
		if err != nil {
			fmt.Printf("Can not open file! %s\n", err)
			os.Exit(1)
		}

		buf := bytes.NewBuffer(nil)
		l, err2 := io.Copy(buf, file)
		file.Close()
		if err2 != nil {
			fmt.Printf("Can not read file! %s\n", err2)
			os.Exit(1)
		}
		
		input := make([]byte, l)
		input = buf.Next(int(l))

		output := blackfriday.MarkdownCommon(input)

//		fmt.Printf("%s", output)
		
		tmpName := file.Name()
		names := strings.Split(tmpName, ".")

		outFile, err3 := os.Create(*outDir + "/" + names[0] + ".html")
		defer outFile.Close()
		if err3 != nil {
			fmt.Printf("Can not open file! %s\n", err3)
			os.Exit(1)
		}

		outFile.Write(output)
	} else {
		fmt.Printf("No filename given!\n")
		os.Exit(1)
	}
}
