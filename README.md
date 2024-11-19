# Downsample_FASTQ

Texas DSHS downsampling pipeline is designed to downsample samples using seqkit (https://github.com/shenwei356/seqkit) in order to reduce coverage. Seqkit allows to randomly select a subset of reads by downsampling by a fixed number of reads or by a proportion of reads. For our purposes, we are randomly selecting a subset of 2,000,000 reads from pair-end FASTQ files.

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
bash seqkit.sh FB_<seq_date>_<instrument>_downsample_samplesheet.csv
```

## Example
```bash
# Downsample by fixed number of reads (2,000,000)
bash seqkit.sh FB_241114_M0922_downsample_samplesheet.csv
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
