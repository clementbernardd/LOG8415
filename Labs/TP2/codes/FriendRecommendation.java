import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.PriorityQueue;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

public class FriendRecommendation extends Configured implements Tool {
   public static void main(String[] args) throws Exception {
      System.out.println(Arrays.toString(args));
      int res = ToolRunner.run(new Configuration(), new FriendRecommendation(), args);
      System.exit(res);
   }

   @Override
   public int run(String[] args) throws Exception {
      System.out.println(Arrays.toString(args));
      Configuration conf = new Configuration();
      conf.set("mapreduce.input.keyvaluelinerecordreader.key.value.separator", "\t");
      Job job = new Job(conf, "FriendRecommendation");
      job.setJarByClass(FriendRecommendation.class);
      job.setMapOutputKeyClass(Text.class);
      job.setMapOutputValueClass(PairWritable.class);

      job.setMapperClass(Map.class);
      job.setReducerClass(Reduce.class);

      job.setInputFormatClass(KeyValueTextInputFormat.class);
      job.setOutputFormatClass(TextOutputFormat.class);

      FileInputFormat.addInputPath(job, new Path(args[0]));
      FileOutputFormat.setOutputPath(job, new Path(args[1]));

      job.waitForCompletion(true);

      return 0;
   }

   public static class Map extends Mapper<Text, Text, Text, PairWritable> {

      @Override
      public void map(Text key, Text value, Context context) throws IOException, InterruptedException {;
         if (value.getLength() != 0) {
           String[] friendsList = value.toString().split(",");
           for (int i = 0; i < friendsList.length; i ++) {
               //adding all degree 1 friends to keep track of the people who are already friends and don't need to be recommended
               context.write(key, new PairWritable(new Text(friendsList[i]), new IntWritable(1)));
               for (int j = i + 1; j < friendsList.length; j++) {
                   //adding all potential degree 2, which are people in the list who are both friends with the person (key)
                   context.write(new Text(friendsList[i]), new PairWritable(new Text(friendsList[j]), new IntWritable(2)));
                   context.write(new Text(friendsList[j]), new PairWritable(new Text(friendsList[i]), new IntWritable(2)));
               }
           }
         } 
      }
   }

   public static class Reduce extends Reducer<Text, PairWritable, Text, Text> {
      @Override
      public void reduce(Text key, Iterable<PairWritable> values, Context context) throws IOException, InterruptedException {
        Iterator<PairWritable> itr = values.iterator();
        //use a hashmap to keep track of the friends of the person and the count
        HashMap<String, Integer> hash = new HashMap<String, Integer>();
          while (itr.hasNext()) {
            PairWritable curEntry = itr.next();
            String friendName = curEntry.getFriend();
            // if this is a degree 1 friend, identify it with -1 and later delete it
            if (curEntry.getDegree() == 1) hash.put(friendName, -1);
            else {
                if (hash.containsKey(friendName)) {
                    //if person already in the list
                    if (hash.get(friendName) != -1) {
                        //make sure that the friends pair are not degree 1 friends
                        // if not, increase the count by 1
                        hash.put(friendName, hash.get(friendName) + 1);
                    }
                }
                else hash.put(friendName, 1);
            }
          }

          // remove all degree 1 friend, sort top 10 with a top 10 heap (implemented by PriorityQueue), output 
          PriorityQueue<Entry<String, Integer>> top10heap = new PriorityQueue<Entry<String, Integer>>(10, new Comparator<Entry<String, Integer>>() {

          @Override
          public int compare(Entry<String, Integer> o1,
                  Entry<String, Integer> o2) {
              return o2.getValue() - o1.getValue();
          }
          });

          for (Entry<String, Integer> pairs: hash.entrySet()) {
            if (!pairs.getValue().equals(-1)) top10heap.add(pairs);
          }
          StringBuffer output = new StringBuffer();
          int count = 0;
          int size = top10heap.size();
          while (!top10heap.isEmpty()) {
            output.append(top10heap.poll().getKey());
            if (count >= 9 || count >= size-1) break;
            count ++;
            output.append(",");
          }
          context.write(key, new Text(output.toString()));
      }
   }


   /*
    * the implementation of a friend and the degree with the WritableComparable interface required as a value 
    */
   public static class PairWritable implements Writable {
     private Text friend;
     private IntWritable degree;
  
     public PairWritable() {
         this.friend = new Text();
         this.degree = new IntWritable();
     }
  
     public PairWritable(Text friend1, IntWritable degree) {
         this.friend = friend1;
         this.degree = degree;
     }

     @Override
     public void readFields(DataInput in) throws IOException {
         this.friend.readFields(in);
         this.degree.readFields(in);
     }

     @Override
     public void write(DataOutput out) throws IOException {
         friend.write(out);
         degree.write(out);
     }
  
     public int getDegree() {
         return degree.get();
     }
  
     public String getFriend() {
         return friend.toString();
     }
   }

}
