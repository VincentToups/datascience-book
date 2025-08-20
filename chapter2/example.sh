echo Data Set Columns:
head -n1 dogs-ranking-dataset.csv | tr ',' '\n'
echo -----------------
echo Type Counts
tail -n+2 dogs-ranking-dataset.csv | cut -d',' -f 2 | sort | uniq -c