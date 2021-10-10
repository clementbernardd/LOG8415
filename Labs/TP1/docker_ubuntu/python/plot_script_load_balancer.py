import json
import matplotlib.pyplot as plt
from datetime import datetime
import os
import fire
from math import sqrt
import numpy as np



class PlottingLoadBalancer(object):
    """Class that will plot the metrics for the loadbalancer."""
    def __init__(self, path: str):
        """
        Args :
            path (str) : the path to the metrics of the clusters
        """
        self.origin_path = path
        self.path = os.path.join(path, 'elb')
        self.metrics = os.listdir(self.path)

    def open(self, path: str):
        """Open a file and convert it to usable data."""
        with open(path) as f:
            data = json.load(f)
        data_values = data['Datapoints']
        data_values.sort(key=lambda x: x["Timestamp"])
        X = [datetime.strptime(x['Timestamp'], "%Y-%m-%dT%H:%M:%SZ") for x in data_values]
        Y = [x['Sum'] for x in data_values]
        return {'time': X, 'metric': Y}


    def _plot(self, data):
        """Do the plotting process."""
        N = int(sqrt(len(data)))
        figure, ax = plt.subplots(figsize=(12,8), nrows=N+1, ncols=N+1)
        ax = np.array(ax)
        for i, (metric_name, value) in enumerate(data.items()):
            x,y = value['time'], value['metric']
            ax.flatten()[i].plot(x,y, '+-')
            ax.flatten()[i].set_title(metric_name, fontsize=8)
            ax.flatten()[i].set_xlabel('Time')
            ax.flatten()[i].tick_params(axis='x', labelsize=8)
            ax.flatten()[i].tick_params(axis='y', labelsize=8)
            ax.flatten()[i].tick_params(axis='x', labelrotation=90)
            ax.flatten()[i].grid(True)
        figure.suptitle("Elasic Load Balancer metrics")
        figure.savefig(os.path.join(self.origin_path, 'figures','elb_figure.png'))
        plt.tight_layout()
        plt.show()

    def _plot_metric(self):
        data = {}
        for metric in self.metrics:
            value = self.open(path=os.path.join(self.path, metric, 'elb.json'))
            if value['metric'] != len(value['metric']) * [0.0] and len(value['metric']) > 1:
                data[metric] = value
        self._plot(data)

    def plot_elb_metrics(self):
        """Plot the instance metrics"""
        self._plot_metric()


if __name__ == '__main__':
    fire.Fire(PlottingLoadBalancer)
