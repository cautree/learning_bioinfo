process SUMMARIZE {
	
	input: 
 	 path(metrics)

  output:
   path("*") 

	"""
	SummarizeAssembly.py ${params.run} 
	"""
}