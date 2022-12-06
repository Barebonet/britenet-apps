/**
 * Created by bartosz.rozpara on 14.11.2022.
 */

@IsTest
global class HA_RestMockService implements HttpCalloutMock {
    final Map<String, HttpCalloutMock> requests;

    global HA_RestMockService(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }

    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }

    global HttpResponse respond(HttpRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        if(mock != null) {
            return mock.respond(req);
        }
        return mock.respond(req);
    }
}