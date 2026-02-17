import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
// import java.io.FileInputStream;
// import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

class PhoneNumber implements Serializable {
    String phoneType;
    String number;

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("PhoneNumber(phoneType='");
        sb.append(phoneType);
        sb.append("', number='");
        sb.append(number);
        sb.append("')");
        return sb.toString();
    }
}

class Contact implements Serializable {
    int index;
    String firstName;
    String lastName;
    PhoneNumber[] phoneNumbers;

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("index=");
        sb.append(index);
        sb.append(" firstName='");
        sb.append(firstName);
        sb.append("' lastName='");
        sb.append(lastName);
        sb.append("' phoneNumbers=[");
        for (PhoneNumber number : phoneNumbers) {
            sb.append(number.toString() + ", ");
        }
        sb.replace(sb.length() - 2, sb.length(), "");
        sb.append("]");
        return sb.toString();
    }
}

public class TestPickle {
    public static void main(String[] args) {
        PhoneNumber number1 = new PhoneNumber();
        number1.phoneType = "home";
        number1.number = "123-456-7890";
        PhoneNumber number2 = new PhoneNumber();
        number2.phoneType = "work";
        number2.number = "012-345-6789";

        Contact contact = new Contact();
        contact.index = 1;
        contact.firstName = "John";
        contact.lastName = "Smith";
        contact.phoneNumbers = new PhoneNumber[]{number1, number2};

        byte[] dump = null;
        // To write to a file:
        // FileOutputStream bytesOut = new FileOutputStream("file.bin");
        try (ByteArrayOutputStream bytesOut = new ByteArrayOutputStream();
             ObjectOutputStream out = new ObjectOutputStream(bytesOut)) {
            out.writeObject(contact);
            out.flush();
            dump = bytesOut.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
        }

        Contact recovered = null;
        // To read from a file:
        // FileInputStream bytesIn = new FileInputStream("file.bin");
        try (ByteArrayInputStream bytesIn = new ByteArrayInputStream(dump);
             ObjectInputStream in = new ObjectInputStream(bytesIn)) {
            recovered = (Contact) in.readObject();
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        System.out.println(contact);
        System.out.println(recovered);
    }
}
