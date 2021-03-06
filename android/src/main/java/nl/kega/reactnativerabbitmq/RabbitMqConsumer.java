package nl.kega.reactnativerabbitmq;

import android.util.Log;

import java.io.IOException;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableArray;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.DefaultConsumer;
import com.rabbitmq.client.Envelope;
import com.rabbitmq.client.AMQP;


public class RabbitMqConsumer extends DefaultConsumer {

    private RabbitMqQueue connection;
    private Channel channel;
    
    public RabbitMqConsumer(Channel channel, RabbitMqQueue connection){
        super(channel);

        this.channel = channel;
        this.connection = connection;
    }

    @Override
    public void handleDelivery(String consumerTag, Envelope envelope, AMQP.BasicProperties properties, byte[] body) throws IOException{
       
        String routing_key = envelope.getRoutingKey();
        String exchange = envelope.getExchange();
        String content_type = properties.getContentType();

        Boolean is_redeliver = envelope.isRedeliver();

//        String message = new String(body, "UTF-8");
        String message = Gzip.decompress(body);

//        WritableArray writableArray = Arguments.createArray();
//
//        for (byte b : body) {
//            writableArray.pushInt(b);
//        }

        WritableMap message_params = Arguments.createMap();
        message_params.putString("name", "message");
        message_params.putString("message", message);
        message_params.putString("routing_key", routing_key);
        message_params.putString("exchange", exchange);
        message_params.putString("content_type", content_type);

        this.connection.onMessage(message_params);

        this.channel.basicAck(envelope.getDeliveryTag(), false);
    }



}