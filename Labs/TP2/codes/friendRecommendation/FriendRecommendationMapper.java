import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.*;

public class FriendRecommendationMapper extends MapReduceBase implements Mapper <Text, Text, Text, FriendDegreeWritable> {
        private final static IntWritable one = new IntWritable(1);
        private final static IntWritable two = new IntWritable(2);

        public void map(Text key, Text value, OutputCollector <Text, FriendDegreeWritable> output, Reporter reporter) throws IOException {

                // get friend list
                String valueString = value.toString();
                String[] friends = valueString.split(",");

                // iterate over friend list to add first and second degree friends
                for (int i = 0 ; i < friends.length ; i++) {
                        // add a first degree friend to the current user in the output
                        output.collect(key, new FriendDegreeWritable(new Text(friends[i]), one));

                        // add second degree friends to the observed user in the list (as all the other users in the list are second degree friends)
                        for(int j = i + 1 ; j < friends.length ; j++) {
                                output.collect(new Text(friends[i]), new FriendDegreeWritable(new Text(friends[j]), two));
                                output.collect(new Text(friends[j]), new FriendDegreeWritable(new Text(friends[i]), two));
                        }
                }
        }
}