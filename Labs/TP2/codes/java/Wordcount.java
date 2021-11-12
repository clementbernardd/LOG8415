import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;

import java.util.Arrays;

public class Wordcount {

    public static void main(String[] args)
    {
        SparkConf sparkConf = new SparkConf();

        sparkConf.setAppName("Wordcount");

        //Setting Master for running it from IDE.
        sparkConf.setMaster("local[*]");
        JavaSparkContext sparkContext = new JavaSparkContext(sparkConf);

        /*Reading input file whose path was specified as args[0]*/
        JavaRDD<String> textFile = sparkContext.textFile(args[0]);

        JavaPairRDD<String, Integer> counts = textFile
                .flatMap(s -> Arrays.asList(s.split(" ")).iterator())
                .mapToPair(word -> new Tuple2<>(word, 1))
                .reduceByKey(Integer::sum);

        sparkContext.stop();
        sparkContext.close();
    }
    // Pour run on utilise spark-submit, on met notre fichier en paramètre et notre javafile
}


