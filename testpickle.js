class PhoneNumber {
    phoneType = "";
    number = "";
}

class Contact {
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

const contact = new Contact();
contact.index = 1;
contact.firstName = "John";
contact.lastName = "Smith";
contact.phoneNumbers = [number1, number2];

const encoder = new TextEncoder();
const dump = encoder.encode(JSON.stringify(contact));

const decoder = new TextDecoder();
const recovered = JSON.parse(decoder.decode(dump));

console.log(contact);
console.log(recovered);
