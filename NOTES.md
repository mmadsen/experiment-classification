

10/24/13:  retrofitting slatkin exact results to the postclassification data set completed.  Started previous Friday 11pm, finished next thursday 1pm
analytics/retrofit-slatkin-parallel.py --experiment classification     --debu  1882909.05s user 1551.31s system 392% cpu 133:12:17.21 total

The parallel version with worker threads (4 in the case of the thinkpad), and 1 queueing thread, worked very well.  Operated with zero long term memory 
leakage over a nearly 7 day window running continuously.  

