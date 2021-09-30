import requests
import time 

url_cluster1 = "http://loadbalancer-cluster1-1264284566.us-east-1.elb.amazonaws.com/"
url_cluster2 = 'http://loadbalancer-cluster2-1540764880.us-east-1.elb.amazonaws.com/'


def send_request(url, get_number, cluster=1): 
	"""Send get_number of requests to the url"""
	for i in range(get_number): 
		res = requests.get(url)
		print(f"REQUESTS TO CLUSTER {cluster} \n Answer : {res.text}")
		

send_request(url_cluster1, 1000)
send_request(url_cluster2, 500, cluster=2)
time.sleep(60)
send_request(url_cluster1, 1000, cluster=2)
