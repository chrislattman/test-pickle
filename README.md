# Built-in object serialization in Java, Python, JavaScript, and Go

Python comes with the built-in pickle module, which de/serializes objects into bytes objects and back, or directly to binary files.

With Java, objects to be serialized must implement the Serializable interface. From there, ByteArrayOutputStream/FileOutputStream with ObjectOutputStream are used to serialize objects into byte arrays or binary files, and ByteArrayInputStream/FileInputStream with ObjectInputStream are used to deserialize byte arrays or binary files back into objects.

JavaScript uses the well-known JavaScript Object Notation (JSON) format to serialize JavaScript objects (including class objects) into JSON strings, which can then be converted into a Uint8Array (a byte array) with TextEncoder and back into a JSON string with TextDecoder.

Go de/serializes structs into byte slices and back with the encoding/gob package.
