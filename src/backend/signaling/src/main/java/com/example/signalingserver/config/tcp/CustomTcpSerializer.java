package com.example.signalingserver.config.tcp;

import org.springframework.integration.ip.tcp.serializer.AbstractPooledBufferByteArraySerializer;
import org.springframework.integration.ip.tcp.serializer.SoftEndOfStreamException;
import org.springframework.integration.mapping.MessageMappingException;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class CustomTcpSerializer extends AbstractPooledBufferByteArraySerializer {

    public static final CustomTcpSerializer INSTANCE = new CustomTcpSerializer();

    public static final int STX = 0x02;

    public static final int ETX = 0x03;

    @Override
    public byte[] doDeserialize(InputStream inputStream, byte[] buffer) throws IOException {
        int bite = inputStream.read();
        if (bite < 0) {
            throw new SoftEndOfStreamException("Stream closed between payloads");
        }
        buffer[0] = (byte) bite;
        int length = inputStream.read();
        if (length < 0) {
            throw new SoftEndOfStreamException("Stream closed between payloads");
        }
        buffer[1] = (byte) length;
        int n = 2;
        try {
            if (bite != STX) {
                throw new MessageMappingException("Expected STX to begin message");
            }
            while (length != n) {
                bite = inputStream.read();
                checkClosure(bite);
                buffer[n++] = (byte) bite;
                if (n >= getMaxMessageSize()) {
                    throw new IOException("ETX not found before max message length: " + getMaxMessageSize());
                }
            }
            if (bite != ETX) {
                throw new MessageMappingException("Expected ETX to end message");
            }
            return copyToSizedArray(buffer, n);
        } catch (IOException e) {
            publishEvent(e, buffer, n);
            throw e;
        } catch (RuntimeException e) {
            publishEvent(e, buffer, n);
            throw e;
        }
    }

    @Override
    public void serialize(byte[] bytes, OutputStream outputStream) throws IOException {
        outputStream.write(bytes);
    }
}
