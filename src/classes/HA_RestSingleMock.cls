/**
 * Created by bartosz.rozpara on 14.11.2022.
 */

@IsTest
public with sharing class HA_RestSingleMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;

    public HA_RestSingleMock(Integer code, String status, String body,
            Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.bodyAsString = body;
        this.bodyAsBlob = null;
        this.responseHeaders = responseHeaders;
    }

    public HA_RestSingleMock(Integer code, String status, Blob body,
            Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.bodyAsString = null;
        this.bodyAsBlob = body;
        this.responseHeaders = responseHeaders;
    }

    public HTTPResponse respond(HTTPRequest req) {
        return null;
    }
}