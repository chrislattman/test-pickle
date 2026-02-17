// #include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>
#include <boost/serialization/string.hpp>
#include <boost/serialization/vector.hpp>

class PhoneNumber {
public:
    std::string phoneType;
    std::string number;

    std::string toString() const {
        std::stringstream sb;
        sb << "PhoneNumber(phoneType='" << phoneType << "', number='" << number << "')";
        return sb.str();
    }

private:
    friend class boost::serialization::access; // allows the access class to access private fields/methods

    template<typename T>
    void serialize(T &ar, const unsigned int version) {
        ar & phoneType;
        ar & number;
    }
};

std::ostream& operator<<(std::ostream &str, const PhoneNumber &number) {
    return str << number.toString();
}

class Contact {
public:
    int index;
    std::string firstName;
    std::string lastName;
    std::vector<PhoneNumber> phoneNumbers;

    std::string toString() const {
        std::stringstream sb;
        sb << "index=" << index << " firstName='" << firstName << "' lastName='" << lastName << "' phoneNumbers=[";
        size_t lastIndex = phoneNumbers.size() - 1;
        for (size_t i = 0; i < phoneNumbers.size(); i++) {
            sb << phoneNumbers[i].toString();
            if (i != lastIndex) {
                sb << ", ";
            }
        }
        sb << "]";
        return sb.str();
    }

private:
    friend class boost::serialization::access; // allows the access class to access private fields/methods

    template<typename T>
    void serialize(T &ar, const unsigned int version) {
        ar & index;
        ar & firstName;
        ar & lastName;
        ar & phoneNumbers;
    }
};

std::ostream& operator<<(std::ostream &str, const Contact &contact) {
    return str << contact.toString();
}

int main() {
    PhoneNumber number1;
    number1.phoneType = "home";
    number1.number = "123-456-7890";
    PhoneNumber number2;
    number2.phoneType = "work";
    number2.number = "012-345-6789";

    Contact contact;
    contact.index = 1;
    contact.firstName = "John";
    contact.lastName = "Smith";
    contact.phoneNumbers = {number1, number2};

    std::ostringstream os(std::ios::binary);
    // To write to a file:
    // std::ofstream os("file.bin", std::ios::binary);
    boost::archive::binary_oarchive oa(os);
    oa << contact;
    std::string byte_str = os.str();
    std::vector<unsigned char> dump(byte_str.begin(), byte_str.end());

    std::string input_str(dump.begin(), dump.end());
    std::istringstream is(input_str, std::ios::binary);
    // To read from a file:
    // std::ifstream is("file.bin", std::ios::binary);
    boost::archive::binary_iarchive ia(is);
    Contact recovered;
    ia >> recovered;

    std::cout << contact << std::endl;
    std::cout << recovered << std::endl;
    return 0;
}
