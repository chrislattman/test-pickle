import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
// import java.io.FileInputStream;
// import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

public class TestPickle {
    public static void main(String[] args) {
        PhoneNumber number1 = new PhoneNumber();
        number1.setPhoneType("home");
        number1.setNumber("123-456-7890");
        PhoneNumber number2 = new PhoneNumber();
        number2.setPhoneType("work");
        number2.setNumber("012-345-6789");

        Contact contact = new Contact();
        contact.setIndex(1);
        contact.setFirstName("John");
        contact.setLastName("Smith");
        contact.setPhoneNumbers(new PhoneNumber[]{number1, number2});

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

class PhoneNumber implements Serializable {
    private String phoneType;
    private String number;

    public String getPhoneType() {
        return phoneType;
    }

    public void setPhoneType(String phoneType) {
        this.phoneType = phoneType;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

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
    private int index;
    private String firstName;
    private String lastName;
    private PhoneNumber[] phoneNumbers;

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public PhoneNumber[] getPhoneNumbers() {
        return phoneNumbers;
    }

    public void setPhoneNumbers(PhoneNumber[] phoneNumbers) {
        this.phoneNumbers = phoneNumbers;
    }

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
        for (int i = 0; i < phoneNumbers.length; i++) {
            sb.append(phoneNumbers[i].toString());
            if (i != phoneNumbers.length - 1) {
                sb.append(", ");
            }
        }
        sb.append("]");
        return sb.toString();
    }
}
