# Carolina-Edible-Plants
Companion maps for Edible Wild Plants of the Carolinas: A Forager’s Companion. 



1. Download BIOCLIM layers here: [https://www.worldclim.org/data/worldclim21.html](https://www.worldclim.org/data/worldclim21.html)
2. Unzip BIOCLIM files, and edit path to files in the top of CarolinaWildEdibles.R
3. Other shapefiles should be downloaded automatically the first time the script is run. If not, you can download them here: [https://cornell.box.com/s/d2u8tzl85el2azdgampryvog09m8l4no](https://cornell.box.com/s/d2u8tzl85el2azdgampryvog09m8l4no)
4. Dependencies -- there are a bunch and don't always install nicely. In R 4.0.3 on macOS most downloaded through the built-in install.packages, but iNat had to be downloaded from Github then installed from source. You can try the install script but it may or may not work.
5. Once all dependencies are working, edit the variables in the top of CarolinaWildEdibles.R or Isoetes_SDM.R for your purposes. The cities are hardcoded around line 74 and can be changed. Everything else *should* work automatically. If working outside the Southeast, probably better to use Isoetes_SDM.R which covers all of North America.
6. Run the CarolinaWildEdibles.R script from command line with Rscript, passing a genus or species name as an argument like this `Rscript CarolinaWildEdibles.R "Morus alba"` or `Rscript Isoetes_SDM.R "Isoetes engelmannii" `or as a batch from a text with one name per line `while read line ; do Rscript CarolinaWildEdibles.R "$line" ; done < species_list.txt`. 
