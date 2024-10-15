class PhoneNumber {
    phoneType = "";
    number = "";
}

class PhoneBook {
    index = 0;
    firstName = "";
    lastName = "";
    phoneNumbers = [];
}

const number1 = new PhoneNumber();
number1.phoneType = "home";
number1.number = "123-456-7890";
const number2 = new PhoneNumber();
number2.phoneType = "work";
number2.number = "012-345-6789";

const phonebook = new PhoneBook();
phonebook.index = 1;
phonebook.firstName = "John";
phonebook.lastName = "Smith";
phonebook.phoneNumbers = [number1, number2];

const encoder = new TextEncoder();
const dump = encoder.encode(JSON.stringify(phonebook));

const decoder = new TextDecoder();
const recovered = JSON.parse(decoder.decode(dump));

console.log(phonebook);
console.log(recovered);
