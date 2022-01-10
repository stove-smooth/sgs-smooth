package com.example.communityserver.util;

import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.example.communityserver.exception.CustomException;
import lombok.RequiredArgsConstructor;
import org.apache.tika.Tika;
import org.apache.tika.mime.MimeType;
import org.apache.tika.mime.MimeTypeException;
import org.apache.tika.mime.MimeTypes;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.UUID;

import static com.example.communityserver.exception.CustomExceptionStatus.FILE_CONVERT_ERROR;
import static com.example.communityserver.exception.CustomExceptionStatus.FILE_EXTENSION_ERROR;

@RequiredArgsConstructor
@Component
public class AmazonS3Connector {

    /**
     * Todo
     * 파일 암호화(ex. AES256)
     */

    private final AmazonS3Client amazonS3Client;
    private final Tika tika = new Tika();
    private final static String IMAGE_DIR = "discord/images/";

    @Value("${cloud.aws.s3.bucket}")
    public String bucket;

    @Value("${cloud.aws.cloudfront.url}")
    public String cloudfrontUrl;

    public String uploadImage(
            Long id,
            MultipartFile multipartFile
    ) {
        File file = convertToFile(multipartFile);

        String fileName = IMAGE_DIR + id + "/" + UUID.randomUUID() + extension(multipartFile);

        amazonS3Client.putObject(new PutObjectRequest(bucket, fileName, file));
        file.delete();

        return cloudfrontUrl + fileName;
    }

    private File convertToFile(MultipartFile multipartFile) {
        File convertedFile = new File(multipartFile.getOriginalFilename());
        try (FileOutputStream fos = new FileOutputStream(convertedFile)) {
            fos.write(multipartFile.getBytes());
        } catch (IOException e) {
            throw new CustomException(FILE_CONVERT_ERROR);
        }
        return convertedFile;
    }

    /**
     * 파일 확장자 확인 (tika)
     */
    private String extension(MultipartFile multipartFile) {
        MimeTypes mTypes = MimeTypes.getDefaultMimeTypes();
        try {
            MimeType mimeType = mTypes.forName(
                    tika.detect(multipartFile.getBytes())
            );
            return mimeType.getExtension();
        } catch (MimeTypeException | IOException e) {
            throw new CustomException(FILE_EXTENSION_ERROR);
        }
    }
}