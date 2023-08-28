########## PREDICTIVE MODEL ############
regression <- function(train_data, train_target, test_data, features, method = "knn", fixed_param = NA){
  
  df <- cbind(train_data[,features], lab = train_target)
  if(method == "linear"){
    mod <- lm(lab ~ ., data = df)
    param = NA
    sign = coef(mod)[-1] > 0
  }
  else if(method == "censreg"){
    require(VGAM)
    mod <- VGAM::tobit(lab ~ ., data = df, right = 60)
    param = NA
    sign = integer(0)
  }
  else if(method == "knn"){
    if(is.na(fixed_param)){
      control = caret::trainControl(method = "cv", number = 5)
      grid = data.frame(k = seq(1, 7, by  = 2))
    }
    else{
      control = caret::trainControl(method = "none")
      grid = data.frame(k = fixed_param)
    }
    mod <- caret::train(lab ~ ., 
                        data = df, 
                        method = "knn", 
                        trControl = control, 
                        tuneGrid = grid)
    param = mod$finalModel$k
    sign = integer(0)
  }
  else if(method == "svm"){
    if(is.na(fixed_param)){
      control = caret::trainControl(method = "cv", number = 5)
      grid = data.frame(C = c(1,10,100))
    }
    else{
      control = caret::trainControl(method = "none")
      grid = data.frame(C = fixed_param)
    }
    mod <- caret::train(lab ~ ., 
                        data = df, 
                        method = 'svmRadialCost', 
                        trControl = control, 
                        tuneGrid = grid)
    param = mod$finalModel@param$C
    sign = integer(0)
  }

  ### prediction ###  
  pred_train = predict(mod, df)
  pred_test = predict(mod, test_data[,features])
  
  return(list(pred_train = pred_train, 
              pred_test = pred_test, 
              param = param,
              sign = sign))
}

######## Evaluate metrics ###############
eval_all <- function(features, train_data, test_data, train_target, test_target, fixed_param_knn = NA, fixed_param_svm = NA){
  eval_metrics_regression <- function(y_pred, y_true){
    res <- data.frame(value = c(MLmetrics::RMSE(y_pred = y_pred, y_true = y_true),  
                                MLmetrics::R2_Score(y_pred = y_pred, y_true = y_true)),
                      metric = c("RMSE", "R2"))
    return(res)
  }
  
  res = data.frame()

  if(length(features) == 0){
    print("no features")
    pred_train = rep(mean(train_target$category), length(train_target$category))
    pred_test = rep(mean(train_target$category), length(test_target$category))
    param = NA
    sign = integer(0)
    
    res = rbind(res,
                cbind(
                  eval_metrics_regression(pred_train, train_target$category),
                  model = "no_feats",
                  type = "train"),
                cbind(
                  eval_metrics_regression(pred_test, test_target$category),
                  model = "no_feats",
                  type = "test"))
  } 
  else {
    lm_train = regression(train_data = train_data, train_target = train_target$category, test_data = test_data, features = features, method = "linear")
    lm_pred_train = lm_train$pred_train
    lm_pred_test = lm_train$pred_test
    sign = ifelse(lm_train$sign, 1, -1)
    sign[is.na(sign)] <- 0
    
    knn_train = regression(train_data = train_data, train_target = train_target$category, test_data = test_data, features = features, method = "knn", fixed_param = fixed_param_knn)
    knn_pred_train = knn_train$pred_train
    knn_pred_test = knn_train$pred_test
    param = c(knn = knn_train$param)
    
  res = rbind(res,
              cbind(
                eval_metrics_regression(lm_pred_train, train_target$category),
                model = "linear",
                type = "train"),
              cbind(
                eval_metrics_regression(lm_pred_test, test_target$category),
                model = "linear",
                type = "test"),
              cbind(
                eval_metrics_regression(knn_pred_train, train_target$category),
                model = "knn",
                type = "train"),
              cbind(
                eval_metrics_regression(knn_pred_test, test_target$category),
                model = "knn",
                type = "test")
  )
  }

  return(list(res = res, param = param, sign = sign))
}

# Nogueira stability
getStability <- function(X, alpha = 0.05) {
  M <- nrow(X)
  d <- ncol(X)
  hatPF <- colMeans(X)
  kbar <- sum(hatPF)
  v_rand <- (kbar/d)*(1-kbar/d)
  stability <- 1-(M/(M-1))*mean(hatPF*(1-hatPF))/v_rand ## this is the stability estimate
  
  ## then we compute the variance of the estimate
  ki <- rowSums(X)
  phi_i <- rep(0,M)
  for(i in 1:M){
    phi_i[i] <- (1/v_rand)*((1/d)*sum(X[i,]*hatPF)-(ki[i]*kbar)/d^2-(stability/2)*((2*kbar*ki[i])/d^2-ki[i]/d-kbar/d+1))
  }
  phi_bar <- mean(phi_i)
  var_stab <- (4/M^2)*sum((phi_i-phi_bar)^2) ## this is the variance of the stability estimate
  
  ## then we calculate lower and upper limits of the confidence intervals
  z <- qnorm(1-alpha/2) # this is the standard normal cumulative inverse at a level 1-alpha/2
  upper <- stability+z*sqrt(var_stab) ## the upper bound of the (1-alpha) confidence interval
  lower <- stability-z*sqrt(var_stab) ## the lower bound of the (1-alpha) confidence interval
  
  return(data.frame(value = stability, 
                    variance = var_stab, 
                    lower = lower, 
                    upper = upper))
  
}

######## ONLY FOR HISTOGRAM ###############
fold_analysis <- function(fold, features, k){
  train_data = data_list[[fold]]$train_data
  test_data = data_list[[fold]]$test_data
  train_target = data_list[[fold]]$train_target$category
  test_target = data_list[[fold]]$test_target$category

  knn_fit <- regression(train_data, train_target, test_data, features, method = "knn")
  
  out <- data.frame(id = rownames(test_data), true = test_target, pred = knn_fit$pred_test)
  return(out)
}
