# nahTourBand Roadbook

This set of scripts loads a set of pictures as waypoints in the nahtourband. 
See `setenv-template.sh` for configuration. 

Further prerequisites are AWS CLI, an AWS user with read access to S3 bucket, 
and an AirTable, compliant with the data structure in `load_data.sh`.
All pictures provided in an AWS bucket and 
can be loaded for track 4 / variant 0 as folllows:

```
./load_all_data remote 4 0
```
