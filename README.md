# Downsample_FASTQ

Texas DSHS downsampling pipeline is designed to downsample samples using seqkit (https://github.com/shenwei356/seqkit) in order to reduce coverage. Seqkit allows to randomly select a subset of reads by downsampling by a fixed number of reads or by a proportion of reads.  

## Installation
For installation details, refer to https://github.com/shenwei356/seqkitz

```bash
# Initialize conda
source miniconda3/etc/profile.d/conda.sh
# Create conda virtual environment
conda create --name seqkit python=3.6
# Activate conda virtual environment
conda activate seqkit
# Install seqkit
conda install -c bioconda seqkit
```

## Usage
```bash
bash seqkit.sh <run_name>_downsample_list.csv <reads_dir> <downsample_type> <reads_to_remove>
```

## Example
```bash
# Downsample by proportion of reads
bash seqkit.sh TX-M0922-241114_downsample_list.csv reads p 0.5
# Downsample by number of reads
bash seqkit.sh TX-M0922-241114_downsample_list.csv reads n 10,000
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
