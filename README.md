The challenge of the Enigma project is to build algorithms that can encrypt and decrypt messages.

The encryption algorithm combines is based off of the Caesar Cypher and uses a repeating set of "character shifts" to encrypt and decrypt messages. My solution has three main classes.

The Cypher class is responsible for creating the character shift values from a given date and key. It also stores these states to be used by other classes.

The Encoder class is responsible for using the cypher to encrypt and decrypt messages. It has methods related to cleaning and translating text between encrypted and decrypted states. The CodeBreaker class is a child of the Encoder class and has additional methods for decryption without needing a complete cypher.

The Enigma class ties it all together. It gathers the messages, keys, and dates and calls the appropriate methods to respond to user inputs.


Self-evaluation:
I believe I achieved a 4 in all categories.

Functionality: I developed a cracking method and implemented all CLI requirements. I also developed a second cracking method (crack_easy) that decrypts without either date or key. This method returns the correct decryption but does not actually crack the key.

OOP: I implemented both inheritance and used a module. My classes are described above and make logical sense. This setup allowed me to easily implement my crack method by allowing the CodeBreaker class to inheriting many of the text manipulation methods from the Encoder class while overwriting the initialize method and adding additional functionality specific to cracking. Both of these classes are able to leverage the same cypher object, which allows some of the more complicated and confusing parts of the encryption algorithm to be encapsulated outside of the text manipulation efforts of the Encoder and CodeBreaker classes. I used a module to enable multiple classes to access the today and random_key methods, allowing these to easily set default argument settings across multiple classes.

Ruby Conventions and Mechanics: All of my iteration 3 work uses clearly-named methods that are under 10 lines. Many methods leverage sub-methods and helper methods to improve readability and assist with testing. I used advanced enumerables like each_with_object or each_with_index where needed to avoid unnecessary aggregators and counters. The only code that is less clean is the iteration 4 functionality of my crack methods, which use a very odd forward / backwards looping strategy to quickly break the keys. I could have written cleaner code that ran slower, but I wanted a hyper-efficient strategy to support a crack_hard method that breaks the date as well as the key value. I know this method will require the get_key method to be very efficient.

TDD: I always wrote detailed tests first, then wrote my code. Rather than have a single unit test that confirms the correct output I use multiple unit tests to confirm various details of the output so I can better identify where errors are occurring. For example, I tests that the output is an array, an array of intended length, an array of all expected objects, etc. I usually end my tests with any required integration tests to confirm all the sub-methods are working properly. Many of my tests are integration tests because the methods they are testing are methods that combine multiple smaller methods that have already been unit tested. I used stubs to allow my enigma class to operate with unknown 'today' values, thus sidestepping the problem of this code returning a different value ever day it is tested.

Overall, I really enjoyed this project. I am proud that my code and tests are so much cleaner than what I wrote during the first Battleship project. 
