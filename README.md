
# react-native-rabbitmq

Fork of this [repository](https://github.com/kegaretail/react-native-rabbitmq) with added functionalities.

#### gzip feature ####

2 things:
- RabbitMQ send packets of bytes over the network.
- In mobile applications we tend to minimize the amount of transiting data.

Thus, the use of [*gzip*](https://en.wikipedia.org/wiki/gzip) fit perfectly !

The use is exactly the same from a react-native point of vue, you send your information to the android/iOS bridge as a String and it will be **gzip** before it is sent, same for the received packets, they will be **ungzip** upon reception and transmit to the react-native side as a String.

