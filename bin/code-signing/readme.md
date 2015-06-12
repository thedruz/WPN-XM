Usage:

	makecertx.exe -n "CN=PowerShell Local Certificate Root" -a sha1 -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer -ss Root -sr localMachine
	makecertx -pe -n "CN=Loggan" -ss MY -a sha1 -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -ic root.cer

	signtoolx.exe sign /a /tr http://timestamp.comodoca.com/rfc3161 file.exe