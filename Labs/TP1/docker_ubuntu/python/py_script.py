import time
import requests
import fire


class ScenarioRequest(object):
    """Implementation of the different scenarios."""
    def __init__(
            self,
            url:str,
    ):
        """
        Initialisation.
        :param url: the dns of the load balancer
        """
        self.url = url

    @classmethod
    def consumeGETRequestSync(cls, url: str, count: int):
        """Get request."""
        r = requests.get(url)
        print(f"REQUEST {count} | CODE : {r.status_code} | CONTENT : {r.text}")

    def _run_requests(self, N: int):
        """Run N requests."""
        for i in range(N):
            self.consumeGETRequestSync(self.url, count=i)

    def _scenario1(self):
        """Run the scenario on cluster 1 : 1000 GET requests."""
        print("RUN SCENARIO 1 : 1000 GET REQUESTS")
        self._run_requests(N=10)
        print("END SCENARIO 1")

    def _scenario2(self):
        """Run the scenario on cluster 2 : 500 GET, sleep of 60 secondes, 1000 GET requests."""
        print("RUN SCENARIO 2 : 500 GET REQUESTS, 1 MINUTE SLEEP AND 1000 GET REQUESTS")
        self._run_requests(N=50)
        print("SLEEP OF 1 MINUTE")
        time.sleep(1)
        self._run_requests(N=10)
        print("END SCENARIO 2")

    def run_scenario(self):
        """Run the given scenario."""
        self._scenario1()
        print("SLEEP BEFORE SCENARIO 2")
        time.sleep(1)
        self._scenario2()
        print("SLEEP AFTER SCENARIO 2")
        time.sleep(1)

if __name__ == '__main__':
    fire.Fire(ScenarioRequest)
