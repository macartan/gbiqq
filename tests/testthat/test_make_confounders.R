

context("Testing make_confounds")

testthat::skip_on_cran()
testthat::test_that(

	desc = "Check messages.",

	code = {
		model <- make_model("X -> Y")
		expect_message(make_confounds_df(model))
		expect_warning(model <- model %>%
									 	set_confound(list(X = 'X==1')))
	}
)

testthat::test_that(

	desc = "Set confounds",

	code = {
		## passer function
		model_1 <- make_model('X -> Y') %>%
			set_confound('Y <-> X')
		model_2 <- make_model('X -> Y') %>%
		  set_confound('Y <-> X')
		expect_identical(model_1, model_2)
	}
)


testthat::test_that(

  desc = "Confound errors",

  code = {
    ## passer function
    model_1 <- make_model('X -> M -> Y') %>%
      set_confound("Y <-> X") %>%
      set_confound('Y <-> M')
    expect_identical(model_1, model_2)
  }
)



