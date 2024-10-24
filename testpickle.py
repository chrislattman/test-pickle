import pickle
from typing import List

class PhoneNumber:
    phoneType: str
    number: str

    def __str__(self) -> str:
        return f"PhoneNumber(phoneType='{self.phoneType}', number='{self.number}')"


class Contact:
    index: int
    firstName: str
    lastName: str
    phoneNumbers: List[PhoneNumber]

    def __str__(self) -> str:
        string = f"index={self.index} firstName='{self.firstName}' lastName='{self.lastName}' phoneNumbers=["
        for elem in self.phoneNumbers:
            string += f"{elem}, "
        string = string.removesuffix(", ")
        return string + "]"


number1 = PhoneNumber()
number1.phoneType = "home"
number1.number = "123-456-7890"
number2 = PhoneNumber()
number2.phoneType = "work"
number2.number = "012-345-6789"

contact = Contact()
contact.index = 1
contact.firstName = "John"
contact.lastName = "Smith"
contact.phoneNumbers = [number1, number2]

# To write to a file:
# with open("file.bin", "wb") as f:
#     pickle.dump(contact, f)
dump = pickle.dumps(contact)

# To read from a file:
# with open("file.bin", "rb") as f:
#     recovered = pickle.load(f)
recovered = pickle.loads(dump)

print(contact)
print(recovered)
