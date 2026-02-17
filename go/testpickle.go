package main

import (
	"bytes"
	"encoding/gob"
	"fmt"
	// "os"
	"strings"
)

type PhoneNumber struct {
	PhoneType string
	Number    string
}

type Contact struct {
	Index        int32
	FirstName    string
	LastName     string
	PhoneNumbers []PhoneNumber
}

func (p PhoneNumber) String() string {
	return fmt.Sprintf("PhoneNumber(phoneType='%v', number='%v')", p.PhoneType, p.Number)
}

func (c Contact) String() string {
	result := fmt.Sprintf("index=%v firstName='%v' lastName='%v' phoneNumbers=[", c.Index, c.FirstName, c.LastName)
	for _, elem := range c.PhoneNumbers {
		result += fmt.Sprintf("%v, ", elem)
	}
	result = strings.TrimSuffix(result, ", ")
	return result + "]"
}

func main() {
	number1 := PhoneNumber{PhoneType: "home", Number: "123-456-7890"}
	number2 := PhoneNumber{PhoneType: "work", Number: "012-345-6789"}

	contact := Contact{Index: 1, FirstName: "John", LastName: "Smith", PhoneNumbers: []PhoneNumber{number1, number2}}

	var buf bytes.Buffer
	enc := gob.NewEncoder(&buf)
	err := enc.Encode(contact)
	if err != nil {
		panic(err)
	}
	dump := buf.Bytes()
	// To write to a file:
	// err = os.WriteFile("file.bin", dump, 0644)
	// if err != nil {
	// 	panic(err)
	// }

	var recovered Contact
	// To read from a file:
	// dump, err = os.ReadFile("file.bin")
	// if err != nil {
	// 	panic(err)
	// }
	dec := gob.NewDecoder(bytes.NewBuffer(dump))
	err = dec.Decode(&recovered)
	if err != nil {
		panic(err)
	}

	fmt.Println(contact)
	fmt.Println(recovered)
}
