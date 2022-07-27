# format gff3 to add Names with roman numeral chromosomes
python format_gff_t.py Vfaba.Tiffany.v1.gff3 > Vfaba.Tiffany.v1.roman2.gff3

# run EMBLmyGFF3 for the first time
EMBLmyGFF3 Vfaba.Tiffany.v1.roman2.gff3 Vfaba.Tiffany.v1.fa --topology linear --molecule_type 'genomic DNA' --transl_table 1 --species 'Vicia faba' --locus_tag VFT --project_id PRJEB52541 --use_attribute_value_as_locus_tag Name -o result.embl

# prep files for validation
mv result.embl input
gzip input/result.embl

# validate, most likely there will be errors
java -jar webin-cli-4.5.2.jar -validate -context=genome -manifest=manifest.file -userName=xxx -password=xxx -outputDir=output -inputDir=input

# get genes with errors and fix issues/remove
gunzip input/result.embl.gz

python3 list_dogdy_genes_in_embl_file.py input/result.embl output/genome/Tiffany_genome_v1/validate/result.embl.gz.report tiffany_dodgy_gene

grep -P "\tgene\t" Vfaba.Tiffany.v1.roman2.gff3 | fgrep -f tiffany_dodgy_gene | cut -f 9 | cut -f 1 -d ";" | cut -f 2 -d "=" > tiffany_dodgy_gene.ids

source activate agat

agat_convert_sp_gxf2gxf.pl -g Vfaba.Tiffany.v1.roman2.gff3 -o test.gff

#agat gives genes with identical isoforms
#Check13: remove identical isoforms in Vfaba.Tiffany.v1.roman2.agat.log

cp Vfaba.Tiffany.v1.roman2.gff3 Vfaba.Tiffany.v1.roman2.fix.gff3

#rm dup isoforms from Vfaba.Tiffany.v1.roman2.fix.gff3
#remove dup isoform genes from tiffany_dodgy_gene.ids

fgrep -v -f tiffany_dodgy_gene.ids Vfaba.Tiffany.v1.roman2.fix.gff3 > Vfaba.Tiffany.v1.roman2.fix2.gff3


# run EMBLmyGFF3 again
EMBLmyGFF3 Vfaba.Tiffany.v1.roman2.fix2.gff3 Vfaba.Tiffany.v1.fa --topology linear --molecule_type 'genomic DNA' --transl_table 1 --species 'Vicia faba' --locus_tag VFT --project_id PRJEB52541 --use_attribute_value_as_locus_tag Name -o result.fix.embl

# prep files for validation
mv result.fix.embl input2
gzip input2/result.fix.embl

# validate, hopefully errors are gone
java -jar webin-cli-4.5.2.jar -validate -context=genome -manifest=manifest.file2 -userName=xxx -password=xxx -outputDir=output2 -inputDir=input2
