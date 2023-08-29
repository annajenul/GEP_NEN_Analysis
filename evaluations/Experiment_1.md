# Load RENT and UBayFS features

``` r
# load RENT features
RF <- read.csv("../RENT/RENT_features_all.csv")
RF$index = RF$index + 1 # Python-R-conversion of indices
colnames(RF) = c("index", "max_s", "fold")

RF_all <- data.frame(index = rep(c(1:113),5), max_s = rep(113, 113*5), fold = rep(1:5, each = 113))
RF = rbind(RF, RF_all)


feature_df <- cbind(RF, fs = "RENT")
```

``` r
# load UBayFS features
UF <- read.csv("../UBayFS/UBayFS_features_exp1.csv")

feature_df <- rbind(feature_df, cbind(UF, fs = "UBayFS"))
```

``` r
# options for maximum number of features (max_s)
max_s_opts = unique(feature_df$max_s)  # max_s options
fs_opts <- unique(feature_df$fs) # feature selector options
nfolds = max(feature_df$fold) # number of folds
```

# Compute performance metrics

``` r
pred_df <- data.frame()
RED_df <- data.frame()
stability_df <- data.frame()
param_df <- data.frame()

# signs within elementary models
feature_df <- cbind(feature_df, sign = 0)

# PREDICTIONS
for(fs_ in fs_opts){
  for (max_s_ in max_s_opts) {
    set.seed(1)
    for (test_fold in 1:nfolds) {
      
      features = subset(feature_df, (max_s == max_s_) & (fold == test_fold) & (fs == fs_))$index
      eval <- eval_all(features, 
                                train_data = data_list[[test_fold]]$train_data, 
                                test_data = data_list[[test_fold]]$test_data, 
                                train_target = data_list[[test_fold]]$train_target, 
                                test_target = data_list[[test_fold]]$test_target
      )
      
      pred_df <- rbind(pred_df, 
                       cbind(eval$res,
                             max_s = max_s_,
                             fold = test_fold,
                             fs = fs_))
      
      param_df <- rbind(param_df,
                    data.frame(param = eval$param,
                               method = names(eval$param),
                               max_s = max_s_,
                               fold = test_fold,
                               fs = fs_))
      
      feat_inds <- (feature_df$index %in% features & 
                      feature_df$max_s == max_s_ & 
                      feature_df$fold == test_fold & 
                      feature_df$fs == fs_)
      feature_df[feat_inds, "sign"] = feature_df[feat_inds, "sign"] + eval$sign
      
      # RED
      cor_mat <- cor(rbind(data_list[[test_fold]]$train_data[, features],
                           data_list[[test_fold]]$test_data[, features])) # feature-wise correlation matrix
      RED_df <- rbind(RED_df, 
                      data.frame(RED = mean(abs(cor_mat[upper.tri(cor_mat)])),
                                 max_s = max_s_,
                                 fold = test_fold,
                                 fs = fs_))
    }
    
    # stability
    f_mat <- matrix(0, nrow = nfeats, ncol = nfolds)
    features <- subset(feature_df, (max_s == max_s_) & (fs == fs_)) %>% 
      select(index, fold) %>% 
      as.matrix()
    f_mat[features] <- f_mat[features] + 1
    
    stab = getStability(t(f_mat))
    stability_df <- rbind(stability_df, 
                          cbind(max_s = max_s_,
                                fs = fs_,
                                stab))
  }
}

RED_df <- RED_df %>% group_by(max_s, fs) %>% 
  summarize(value = mean(RED), 
            variance = var(RED), 
            lower = min(RED),
            upper = max(RED)) %>% 
  as.data.frame()

summary_df <- pred_df %>% group_by(metric, model, type, max_s, fs) %>%
  summarize(mean = mean(value),
            median = median(value),
            sd = sd(value),
            min = min(value),
            max = max(value)) %>% 
  as.data.frame()
```

``` r
pred_baseline = c()
for (test_fold in 1:nfolds) {
  
  # all features
  features = 1:ncol(data_list[[test_fold]]$train_data)
  eval_baseline_all <- eval_all(features, 
                                train_data = data_list[[test_fold]]$train_data, 
                                test_data = data_list[[test_fold]]$test_data, 
                                train_target = data_list[[test_fold]]$train_target, 
                                test_target = data_list[[test_fold]]$test_target)
  
  pred_baseline <- rbind(pred_baseline, 
                       cbind(eval_baseline_all$res,
                             max_s = "all",
                             fold = test_fold,
                             fs = "none"))
  
  features = c()
  eval_baseline_no_features <- eval_all(features, 
                                train_data = data_list[[test_fold]]$train_data, 
                                test_data = data_list[[test_fold]]$test_data, 
                                train_target = data_list[[test_fold]]$train_target, 
                                test_target = data_list[[test_fold]]$test_target)
  
  pred_baseline <- rbind(pred_baseline, 
                       cbind(eval_baseline_no_features$res,
                             max_s = "none",
                             fold = test_fold,
                             fs = "none"))
}
```

    ## [1] "no features"
    ## [1] "no features"
    ## [1] "no features"
    ## [1] "no features"
    ## [1] "no features"

``` r
print(pred_baseline %>% subset((type=="test") & (metric =="R2") & (max_s =="none")))
```

    ##           value metric    model type max_s fold   fs
    ## 12 -0.000174744     R2 no_feats test  none    1 none
    ## 24 -0.041876692     R2 no_feats test  none    2 none
    ## 36 -0.054206792     R2 no_feats test  none    3 none
    ## 48 -0.010899006     R2 no_feats test  none    4 none
    ## 60 -0.001685231     R2 no_feats test  none    5 none

``` r
print(pred_baseline %>% subset((type=="test") & (metric =="RMSE") & (max_s =="all")))
```

    ##        value metric  model type max_s fold   fs
    ## 3  12.165580   RMSE linear test   all    1 none
    ## 7   1.592269   RMSE    knn test   all    1 none
    ## 15  6.309293   RMSE linear test   all    2 none
    ## 19  1.593255   RMSE    knn test   all    2 none
    ## 27 13.828153   RMSE linear test   all    3 none
    ## 31  1.933754   RMSE    knn test   all    3 none
    ## 39  8.932305   RMSE linear test   all    4 none
    ## 43  1.224745   RMSE    knn test   all    4 none
    ## 51 80.131201   RMSE linear test   all    5 none
    ## 55  1.356466   RMSE    knn test   all    5 none

# PREDICTION PLOT UBAYFS

``` r
plot_performance <- function(fs_ = "UBayFS", type_ = "test", metric_ = "RMSE", model_ = "knn"){
  p <- pred_df %>% subset(fs == fs_ & type == type_ & metric == metric_ & model == model_)  %>% 
    mutate(fold = as.factor(fold)) %>%
    ggplot(aes(x = max_s)) + 
    geom_point(aes(y = value, pch = fold), size = 5) + 
    geom_line(aes(y = value, lty = fold), linewidth = 1) + 
    geom_line(data = summary_df %>% subset(fs == fs_ & type == type_ & metric == metric_ & model == model_),
              aes(x = max_s,
                  y = mean,
                  color = "mean"),
              linewidth = 1) +
    ylim(0, 3.5)+
    ylab("RMSE") +
    xlab("number of features") + 
    scale_x_continuous(breaks = max_s_opts) +
    theme_bw() + 
    theme(text = element_text(size = 22), legend.position = "top") + 
    guides(fill="none", color = guide_legend(title = "")) + 
    scale_fill_manual(values = "red") + 
    scale_color_manual(values = "red")
  
  return(p)
}
     
p <- plot_performance(fs_ = "UBayFS", type_ = "test", metric_ = "RMSE", model_ = "knn")
p
```

![](Experiment_1_files/figure-gfm/prediction%20plot%20UBayFS-1.png)<!-- -->

``` r
p <- plot_performance(fs_ = "RENT", type_ = "test", metric_ = "RMSE", model_ = "knn")
p
```

![](Experiment_1_files/figure-gfm/prediction%20plot%20UBayFS-2.png)<!-- -->

``` r
p <- plot_performance(fs_ = "UBayFS", type_ = "test", metric_ = "RMSE", model_ = "linear")
p
```

![](Experiment_1_files/figure-gfm/prediction%20plot%20UBayFS-3.png)<!-- -->

``` r
p <- plot_performance(fs_ = "RENT", type_ = "test", metric_ = "RMSE", model_ = "linear")
p
```

![](Experiment_1_files/figure-gfm/prediction%20plot%20UBayFS-4.png)<!-- -->

# STABILITY PLOT UBAYFS

``` r
plot_stability <- function(fs_ = "UBayFS"){
  p <- rbind(cbind(stability_df, score = "stability"),
             cbind(RED_df, score = "RED")) %>% subset(fs == fs_)  %>% 
    ggplot(aes(x= max_s, y = value, color = score, fill = score)) + 
    geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.2)+
    geom_point(size = 5) + 
    geom_line(linewidth = 1) + 
    ylim(-0.05,1)+
    ylab("score") +
    xlab("number of features") + 
    scale_x_continuous(breaks=c(5,10,20,30,40)) +
    theme_bw() + 
    theme(text = element_text(size = 22), legend.position = "top", legend.title = element_blank()) 
  
  return(p)
}

p <- plot_stability(fs_ = "UBayFS")
p
```

![](Experiment_1_files/figure-gfm/plot%20stability%20UBayFS-1.png)<!-- -->

``` r
p <- plot_stability(fs_ = "RENT")
p
```

![](Experiment_1_files/figure-gfm/plot%20stability%20UBayFS-2.png)<!-- -->

# IN-DEPTH ANALYSIS FOLD 2 & 4

``` r
max_s_ = 20 # fix max_s

folds = c(2,4)
title = c("worst (fold 2)", "best (fold 4)")
  
fold_res <- data.frame()
  
for(i in 1:length(folds)){
  fold_ = folds[i]
  
  k_U = subset(param_df, (fs == "UBayFS") & (max_s == max_s_) & (fold == fold_) & (method == "knn"))$param
  k_R = subset(param_df, (fs == "RENT") & (max_s == max_s_) & (fold == fold_) & (method == "knn"))$param
  
  fold_res_U <- fold_analysis(fold_, 
                            subset(feature_df, (max_s == max_s_) & (fs == "UBayFS") & (fold == fold_))$index, 
                            k = k_U)
  fold_res_R <- fold_analysis(fold_, 
                            subset(feature_df, (max_s == max_s_) & (fs == "RENT") & (fold == fold_))$index, 
                            k = k_R)
  fold_res <- rbind(fold_res, 
                    cbind(fold_res_U, fs = "UBayFS", fold = title[i]),
                    cbind(fold_res_R, fs = "RENT", fold = title[i])
  )
}

fold_res = fold_res %>% mutate(error = true - pred)

p <- fold_res %>% 
  ggplot(aes(x = error)) + 
    geom_histogram(col = "black", 
                   fill = "white", 
                   binwidth = 1, 
                   linewidth = 1) + 
    scale_x_continuous(breaks = seq(-6, 6, 1)) +  
    geom_vline(aes(xintercept = 0), 
               lty = "dashed", 
               color = "black", 
               linewidth = 1) +
    facet_grid(fold~fs) + 
    theme_bw() + 
    theme(text = element_text(size = 16))
p
```

![](Experiment_1_files/figure-gfm/analyze%20best%20and%20worst%20fold-1.png)<!-- -->

# FEATURE TABLE

``` r
f_mat <- matrix(0, ncol = 2, nrow = nfeats)
sign_mat <- matrix(0, ncol = 2, nrow = nfeats)
colnames(f_mat) <- colnames(sign_mat) <- c("RENT", "UBayFS")

for(fold_ in 1:nfolds){
  for(fs_ in c("RENT", "UBayFS")){
    features <- feature_df %>% subset(max_s == 20 & fs == fs_ & fold == fold_)
    f_mat[features$index, fs_] <- f_mat[features$index, fs_] + 1
    sign_mat[features$index, fs_] <- sign_mat[features$index, fs_] + features$sign
  }
}

feature_counts <- data.frame(block = block_index,
                  prior = ifelse(1:nfeats %in% prior_features_all_ind, "*", ""),
                  name = feat_names,
                  RENT = paste0(f_mat[,"RENT"], 
                                  ifelse(sign_mat[,"RENT"] != 0, paste0("(", 
                                         ifelse(sign_mat[,"RENT"] > 0, 
                                                ifelse(sign_mat[,"RENT"] == f_mat[,"RENT"], "++", "+"),
                                                ifelse(sign_mat[,"RENT"] == -f_mat[,"RENT"], "--", "-")),
                                                ")"), "")),
                  UBayFS = paste0(f_mat[,"UBayFS"], 
                                  ifelse(sign_mat[,"UBayFS"] != 0, paste0("(", 
                                         ifelse(sign_mat[,"UBayFS"] > 0, 
                                                ifelse(sign_mat[,"UBayFS"] == f_mat[,"UBayFS"], "++", "+"),
                                                ifelse(sign_mat[,"UBayFS"] == -f_mat[,"UBayFS"], "--", "-")),
                                                ")"), ""))
                  )

# original order: blood, image, hist, NA, pat_char, treatment; 
# new order: pat_char, blood, hist, image, treatment
block_reordering <- c("1" = "2", "2" = "4","3" = "3","5" = "1","6" = "5")
block_index_new <- block_index %>%
  as.character() %>%
  plyr::revalue(replace = block_reordering) %>%
  as.integer()
feature_order <- order(block_index_new)

write.csv(feature_counts, file = "feature_counts_exp1.csv", row.names = FALSE)
kable(feature_counts[feature_order,], row.names = FALSE)
```

| block | prior | name                                        | RENT  | UBayFS |
|------:|:------|:--------------------------------------------|:------|:-------|
|     5 | \*    | Age at Diagnosis                            | 2     | 2(–)   |
|     5 |       | Time from PET to Metastasis (days)          | 0     | 0      |
|     5 |       | Time from PET to Diagnosis (days)           | 0     | 0      |
|     5 |       | Time from diag to mets (months)             | 0     | 0      |
|     5 |       | Sex                                         | 0     | 0      |
|     5 |       | Loc. Adv. Resectable Disease                | 0     | 0      |
|     5 |       | Loc. Reccurence                             | 0     | 0      |
|     5 |       | Metastatic Disease at Time of Diagnosis     | 3(+)  | 0      |
|     5 |       | Treatment Intention Palliative              | 4(-)  | 3(–)   |
|     5 |       | Prior Other Cancer                          | 2(++) | 2(–)   |
|     5 |       | Living Alone                                | 0     | 0      |
|     5 | \*    | TNM staging Pathological                    | 0     | 0      |
|     5 |       | Stage grouped Stage IV                      | 0     | 0      |
|     5 |       | Mets Bone                                   | 5(–)  | 5(–)   |
|     5 |       | Mets LN Distant                             | 0     | 0      |
|     5 |       | Mets LN Regional                            | 0     | 0      |
|     5 |       | Mets LN Retro                               | 0     | 0      |
|     5 |       | Mets LN                                     | 0     | 0      |
|     5 |       | Mets Liver                                  | 0     | 0      |
|     5 |       | Mets Lung                                   | 0     | 0      |
|     5 |       | Mets Other                                  | 0     | 0      |
|     5 |       | Mets Skin                                   | 0     | 0      |
|     5 |       | Primary Tumour Resected                     | 0     | 0      |
|     5 |       | M-stage M1                                  | 0     | 0      |
|     5 |       | BMI                                         | 1(–)  | 0      |
|     5 |       | Non Smoker                                  | 0     | 0      |
|     5 |       | Smoker                                      | 0     | 0      |
|     5 |       | Radical Surgery                             | 3(++) | 4(+)   |
|     5 |       | Co-morbidity Severity 1                     | 0     | 0      |
|     5 |       | Co-morbidity Severity \> 1                  | 0     | 0      |
|     5 |       | T-stage T2                                  | 0     | 0      |
|     5 |       | T-stage T3                                  | 0     | 0      |
|     5 |       | T-stage T4                                  | 2(–)  | 2(–)   |
|     5 |       | N-stage N1                                  | 0     | 0      |
|     5 |       | N-stage \> N1                               | 0     | 0      |
|     5 | \*    | WHO Perf Stat 1                             | 0     | 0      |
|     5 | \*    | WHO Perf Stat 2                             | 4(–)  | 5(–)   |
|     5 | \*    | WHO Perf Stat 3                             | 0     | 0      |
|     5 | \*    | WHO Perf Stat 4                             | 0     | 0      |
|     1 |       | Abs. Neutrophil Count                       | 0     | 0      |
|     1 | \*    | Albumin                                     | 2     | 5(–)   |
|     1 |       | CRP                                         | 5(-)  | 5(–)   |
|     1 |       | Creatinine                                  | 0     | 0      |
|     1 |       | Haemoglobin                                 | 0     | 0      |
|     1 |       | WBC                                         | 1(–)  | 1(–)   |
|     1 |       | ALP \> Normal \<= 3UNL                      | 4(–)  | 5(-)   |
|     1 |       | ALP \> 3UNL                                 | 1(++) | 2(++)  |
|     1 |       | Chromogranin_A \> Normal \<= 2UNL           | 0     | 0      |
|     1 |       | Chromogranin_A \> 2UNL                      | 0     | 0      |
|     1 | \*    | LDH \> Normal \<= 2UNL                      | 0     | 0      |
|     1 | \*    | LDH \> 2UNL                                 | 0     | 0      |
|     1 |       | NSE \> Normal \<= 2UNL                      | 0     | 0      |
|     1 |       | NSE \> 2UNL                                 | 0     | 0      |
|     1 | \*    | Platelets                                   | 2(–)  | 5(–)   |
|     3 | \*    | Ki-67                                       | 5(–)  | 5(–)   |
|     3 |       | Hist Exam Metastasis                        | 0     | 0      |
|     3 | \*    | Primary Tumour Esophagus                    | 0     | 0      |
|     3 | \*    | Primary Tumour Gallbladder/duct             | 0     | 0      |
|     3 | \*    | Primary Tumour Gastric                      | 0     | 0      |
|     3 | \*    | Primary Tumour Other abdominal              | 0     | 0      |
|     3 | \*    | Primary Tumour Pancreas                     | 1(++) | 0      |
|     3 | \*    | Primary Tumour Rectum                       | 0     | 0      |
|     3 | \*    | Unknown Pr. With Dominance of GI met.       | 0     | 0      |
|     3 |       | Co-existing Neoplasm Adenoma                | 0     | 1(++)  |
|     3 |       | Co-existing Neoplasm Dysplasia              | 0     | 0      |
|     3 |       | No Co-existing Neoplasm                     | 0     | 0      |
|     3 | \*    | Tumour Morphology WD                        | 4(+)  | 4      |
|     3 |       | Chromogranin A Staining                     | 0     | 0      |
|     3 |       | Architecture Infiltrative                   | 1(++) | 0      |
|     3 |       | Architecture Organoid                       | 1(++) | 0      |
|     3 |       | Architecture Solid                          | 0     | 0      |
|     3 |       | Architecture Trabecular                     | 1(–)  | 0      |
|     3 |       | Vessel Pattern Distant                      | 1(++) | 2      |
|     3 |       | Biopsy Location Gastric                     | 0     | 0      |
|     3 |       | Biopsy Location Liver Metastasis            | 0     | 0      |
|     3 |       | Biopsy Location Lymph Node                  | 0     | 0      |
|     3 |       | Biopsy Location Oesophagus                  | 0     | 0      |
|     3 |       | Biopsy Location Pancreas                    | 0     | 0      |
|     3 |       | Biopsy Location Peritoneum                  | 2     | 0      |
|     3 |       | No Stroma                                   | 4(++) | 1(++)  |
|     3 |       | Stroma                                      | 3(++) | 2      |
|     3 |       | Geographic Necrosis                         | 0     | 2      |
|     3 |       | Synaptophysin Staining 2+                   | 0     | 0      |
|     3 |       | Synaptophysin Staining 3+                   | 0     | 1(++)  |
|     2 |       | Injection to Scan \[min\]                   | 2     | 2(++)  |
|     2 |       | Weight \[kg\]                               | 2(–)  | 0      |
|     2 | \*    | Total MTV \[cmˆ3\]                          | 3(+)  | 1(–)   |
|     2 |       | SUVmean                                     | 0     | 0      |
|     2 | \*    | SUVmax                                      | 2     | 4(+)   |
|     2 |       | SUVmean (total)                             | 1(++) | 0      |
|     2 |       | SUVmax (total)                              | 5(–)  | 5(-)   |
|     2 | \*    | Total TLG \[g\]                             | 4     | 2(++)  |
|     2 |       | Institution Rikshospitalet                  | 4(++) | 1(++)  |
|     2 |       | Institution Ullevaall                       | 0     | 0      |
|     2 |       | Height \[cm\]                               | 0     | 0      |
|     2 |       | Glucose \[mmol/L\]                          | 2(–)  | 0      |
|     6 |       | Time from PET to first treatment (days)     | 0     | 0      |
|     6 |       | Chemotherapy Type Cisplatin/Etoposide       | 4(+)  | 3(+)   |
|     6 |       | Chemotherapy Type Other                     | 0     | 0      |
|     6 |       | Chemotherapy Type Temozolomide/Capecitabine | 1(++) | 0      |
|     6 |       | Chemotherapy Type Temozolomide/Everolimus   | 4(++) | 5(+)   |
|     6 |       | Best Response (RECIST) Not Assessed         | 0     | 1(–)   |
|     6 |       | Best Response (RECIST) Only Clinical PD     | 0     | 0      |
|     6 |       | Best Response (RECIST) Partial Response     | 2(–)  | 0      |
|     6 |       | Best Response (RECIST) Progressive Disease  | 0     | 0      |
|     6 |       | Best Response (RECIST) Stable Disease       | 0     | 0      |
|     6 |       | Reintroduction with Cisplatin Etoposide     | 0     | 0      |
|     6 |       | Number of Courses                           | 4(++) | 4(++)  |
|     6 |       | Treatment Stopped Other                     | 1(++) | 2(++)  |
|     6 |       | Treatment Stopped Progression of Disease    | 0     | 0      |
|     6 |       | Treatment Stopped Toxicity                  | 0     | 0      |
|     6 |       | No Progression                              | 5(++) | 3(++)  |
|     6 |       | Progression                                 | 3     | 3(+)   |
