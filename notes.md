HN comment dump from
    https://news.ycombinator.com/item?id=14580698
    https://archive.org/details/14566367HackerNewsCommentsAndStoriesArchivedByGreyPanthersHacker

Get text from HN comment dump:

    cat ~/Downloads/14m_hn_comments_sorted.json | jq '.body.text | values' | sed 's/^"//' | sed 's/"$//'| sed 's/\<p\>/ /g' | sed 's/\\\"/\"/g' | perl -MHTML::Entities -pe 'decode_entities($_);' > hn_comments.txt


  this line breaks everything :(
    https://news.ycombinator.com/item?id=13240
    line 9803 of generated hn_comments.txt
    also https://news.ycombinator.com/item?id=19456

    sed -i.bak -e '9803d' hn_comments.txt
    sed -i.bak -e '9803d' hn_comments.txt
    sed -i.bak -e '14522d' hn_comments.txt
    sed -i.bak -e '14527d' hn_comments.txt

    stop! use latin-1 encoding instead of utf-8, because of course that's the problem!


on docker:
  preprocess

```
python scripts/preprocess.py --input_txt /tensor/14m_hn_comments/hn_comments.txt --output_h5 /tensor/14m_hn_comments/hn_comments.h5 --output_json /tensor/14m_hn_comments/hn_comments.json --encoding latin-1
python scripts/preprocess.py --input_txt /tensor/14m_hn_comments/some_hn_comments.txt --output_h5 /tensor/14m_hn_comments/some_hn_comments.h5 --output_json /tensor/14m_hn_comments/some_hn_comments.json --encoding latin-1
```


before (running with all 14m):
```
root@6b4066354f5e:~/torch-rnn# python scripts/preprocess.py --input_txt /tensor/14m_hn_comments/hn_comments.txt --output_h5 /tensor/14m_hn_comments/hn_comments.h5 --output_json /tensor/14m_hn_comments/hn_comments.json --encoding latin-1
Total vocabulary size: 211
Total tokens in file: 4469685557
  Training size: 3575748447
  Val size: 446968555
  Test size: 446968555
Using dtype  <type 'numpy.uint8'>

Killed
```

After (running with 3m):
```
root@6b4066354f5e:~/torch-rnn# time python scripts/preprocess.py --input_txt /tensor/14m_hn_comments/some_hn_comments.txt --output_h5 /tensor/14m_hn_comments/some_hn_comments.h5 --output_json /tensor/14m_hn_comments/some_hn_comments.json --encoding latin-1
Total vocabulary size: 208
Total tokens in file: 993420901
  Training size: 794736721
  Val size: 99342090
  Test size: 99342090
Using dtype  <type 'numpy.uint8'>

real	6m46.996s
user	6m34.360s
sys	0m3.890s
```

train

```
th train.lua -input_h5 /tensor/14m_hn_comments/some_hn_comments.h5 -input_json /tensor/14m_hn_comments/some_hn_comments.json -checkpoint_name /tensor/14m_hn_comments/cv/checkpoint -gpu -1
```

even less

```
$ time python scripts/preprocess.py --input_txt /tensor/14m_hn_comments/mil_hn_comments.txt --output_h5 /tensor/14m_hn_comments/mil_hn_comments.h5 --output_json /tensor/14m_hn_comments/mil_hn_comments.json --encoding latin-1

Total vocabulary size: 200
Total tokens in file: 317877987
  Training size: 254302391
  Val size: 31787798
  Test size: 31787798
Using dtype  <type 'numpy.uint8'>

$ time th train.lua -input_h5 /tensor/14m_hn_comments/mil_hn_comments.h5 -input_json /tensor/14m_hn_comments/mil_hn_comments.json -checkpoint_name /tensor/14m_hn_comments/cv/checkpoint -gpu -1
$ time th train.lua -input_h5 /tensor/14m_hn_comments/mil_hn_comments.h5 -input_json /tensor/14m_hn_comments/mil_hn_comments.json -checkpoint_name /tensor/14m_hn_comments/cv/checkpoint -print_every 100 -checkpoint_every 20000 -gpu -1
```

sample
```
th sample.lua -checkpoint /tensor/14m_hn_comments/cv/checkpoint_40000.t7 -length 200 -gpu -1
```


starting docker
```
docker run -v ~/repos/tensor:/tensor/ --rm -ti crisbal/torch-rnn:base bash
```
don't do `--rm`!

