use std::fmt;

use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize)]
struct PhoneNumber {
    phone_type: String,
    number: String,
}

impl fmt::Display for PhoneNumber {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "PhoneNumber(phoneType='{}', number='{}')",
            self.phone_type, self.number
        )
    }
}

#[derive(Serialize, Deserialize)]
struct Contact {
    index: i32,
    first_name: String,
    last_name: String,
    phone_numbers: Vec<PhoneNumber>,
}

impl fmt::Display for Contact {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "index={} firstName='{}' lastName='{}' phoneNumbers=[",
            self.index, self.first_name, self.last_name
        )?;

        for (i, phone) in self.phone_numbers.iter().enumerate() {
            write!(f, "{}", phone)?;
            if i != self.phone_numbers.len() - 1 {
                write!(f, ", ")?;
            }
        }

        write!(f, "]")
    }
}

fn main() {
    let number1 = PhoneNumber {
        phone_type: "home".to_owned(),
        number: "123-456-7890".to_owned(),
    };
    let number2 = PhoneNumber {
        phone_type: "work".to_owned(),
        number: "012-345-6789".to_owned(),
    };

    let contact = Contact {
        index: 1,
        first_name: "John".to_owned(),
        last_name: "Smith".to_owned(),
        phone_numbers: [number1, number2].to_vec(),
    };

    let dump = postcard::to_allocvec(&contact).unwrap();
    // To write to a file:
    // std::fs::write("file.bin", &dump).unwrap();

    // To read from a file:
    // let recovered = std::fs::read("file.bin").unwrap();
    let recovered: Contact = postcard::from_bytes(dump.as_slice()).unwrap();

    println!("{contact}");
    println!("{recovered}");
}
