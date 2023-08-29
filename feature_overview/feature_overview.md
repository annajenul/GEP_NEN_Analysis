| Block.name     | Feature.name                            | Missing.values…. | Removed..reason.                                    | Encoding | No.features.after.encoding | Prior.importance |
|:---------------|:----------------------------------------|:-----------------|:----------------------------------------------------|:---------|---------------------------:|:-----------------|
| Baseline blood | 5-HIAA 24h Urine                        | 77.78%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Baseline blood | ALP                                     | 4.76%            |                                                     | ordinal  |                          2 | x                |
| Baseline blood | Absolute Neutrophil Count               | 0.00%            |                                                     | none     |                          1 | x                |
| Baseline blood | Albumin                                 | 0.00%            |                                                     | none     |                          1 |                  |
| Baseline blood | CRP                                     | 0.00%            |                                                     | none     |                          1 |                  |
| Baseline blood | Chromogranin A                          | 17.46%           |                                                     | ordinal  |                          2 |                  |
| Baseline blood | Creatinine                              | 0.00%            |                                                     | ordinal  |                          1 |                  |
| Baseline blood | Haemoglobin                             | 0.00%            |                                                     | ordinal  |                          1 |                  |
| Baseline blood | LDH                                     | 1.59%            |                                                     | ordinal  |                          2 | x                |
| Baseline blood | NSE                                     | 7.94%            |                                                     | ordinal  |                          2 |                  |
| Baseline blood | Platelets                               | 1.59%            |                                                     | ordinal  |                          1 | x                |
| Baseline blood | WBC                                     | 0.00%            |                                                     | ordinal  |                          1 |                  |
| Imaging        | Date of Study                           | 0.00%            | removed (unimportant)                               |          |                         NA |                  |
| Imaging        | Time of Study                           | 0.00%            | removed (unimportant)                               |          |                         NA |                  |
| Imaging        | Institution                             | 0.00%            |                                                     | one-hot  |                          2 |                  |
| Imaging        | Type of Study                           | 0.00%            | removed (no variation)                              |          |                         NA |                  |
| Imaging        | Radiotracer                             | 0.00%            | removed (no variation)                              |          |                         NA |                  |
| Imaging        | Dose \[MBq\]                            | 0.00%            | removed (?)                                         |          |                         NA |                  |
| Imaging        | Time of Injection                       | 0.00%            | removed (covered by Time from Inj. to Scan \[min\]) |          |                         NA |                  |
| Imaging        | Time from Injection to Scan \[hh:mm\]   | 0.00%            | removed (covered by Time from Inj. to Scan \[min\]) |          |                         NA |                  |
| Imaging        | Time from Injection to Scan \[min\]     | 0.00%            |                                                     | none     |                          1 |                  |
| Imaging        | Height \[cm\]                           | 1.59%            |                                                     | none     |                          1 |                  |
| Imaging        | Weight \[kg\]                           | 0.00%            |                                                     | none     |                          1 |                  |
| Imaging        | Glucose \[mmol/L\]                      | 1.59%            |                                                     | none     |                          1 |                  |
| Imaging        | Treatment before Study                  | 0.00%            | removed (?)                                         |          |                         NA |                  |
| Imaging        | Reconstruction Parameters               | 0.00%            | removed (?)                                         |          |                         NA |                  |
| Imaging        | FWHM                                    | 3.17%            | removed (?)                                         |          |                         NA |                  |
| Imaging        | Matrix Size                             | 0.00%            | removed (?)                                         |          |                         NA |                  |
| Imaging        | \# Subsets                              | 3.17%            | removed (?)                                         |          |                         NA |                  |
| Imaging        | \# Iterations                           | 3.17%            | removed (?)                                         |          |                         NA |                  |
| Imaging        | Total MTV \[cmˆ3\]                      | 0.00%            |                                                     | none     |                          1 | x                |
| Imaging        | SUVmean                                 | 0.00%            |                                                     | none     |                          1 |                  |
| Imaging        | SUVmax                                  | 0.00%            |                                                     | none     |                          1 |                  |
| Imaging        | SUVmean (total)                         | 0.00%            |                                                     | none     |                          1 |                  |
| Imaging        | SUVmax (total)                          | 0.00%            |                                                     | none     |                          1 |                  |
| Imaging        | Total TLG \[g\]                         | 0.00%            |                                                     | none     |                          1 | x                |
| Imaging        | SRI                                     | 33.33%           | removed (\>25% NA)                                  |          |                         NA |                  |
| New Histology  | Re-classified                           | 0.00%            | removed (no variation)                              |          |                         NA |                  |
| New Histology  | Re-classified Ki-67 only                | 0.00%            | removed (no variation)                              |          |                         NA |                  |
| New Histology  | Tumour Morphology LC/SC                 | 0.00%            | removed (?)                                         |          |                         NA |                  |
| New Histology  | Re-classified Morphology only           | 0.00%            | removed (no variation)                              |          |                         NA |                  |
| New Histology  | Differentiation                         | 0.00%            | removed (covered by Hist Exam Metastasis?)          | one-hot  |                          0 |                  |
| New Histology  | Hist Exam Metastasis                    | 0.00%            |                                                     | one-hot  |                          1 |                  |
| New Histology  | Hist Exam Primary Tumour                | 0.00%            | removed (covered by Hist Exam Metastasis?)          | one-hot  |                          0 |                  |
| New Histology  | Ki-67                                   | 0.00%            |                                                     | none     |                          1 | x                |
| New Histology  | Ki-67 grouping                          | 0.00%            | removed (covered by Ki-67)                          |          |                         NA |                  |
| New Histology  | Primary Tumour                          | 0.00%            |                                                     | one-hot  |                          7 |                  |
| New Histology  | Tumour Morphology                       | 0.00%            |                                                     | ordinal  |                          0 |                  |
| New Histology  | Architecture                            | 1.59%            |                                                     | one-hot  |                          4 |                  |
| New Histology  | Vessel Pattern                          | 1.59%            |                                                     | one-hot  |                          1 |                  |
| New Histology  | Biopsy Location                         | 3.17%            |                                                     | one-hot  |                          6 |                  |
| New Histology  | Co-existing Neoplasm                    | 0.00%            |                                                     | one-hot  |                          4 |                  |
| New Histology  | Co-existing NET                         | 0.00%            | removed (no variation)                              |          |                         NA |                  |
| New Histology  | Stroma                                  | 1.59%            |                                                     | one-hot  |                          2 |                  |
| New Histology  | Geographic Necrosis                     | 1.59%            |                                                     | one-hot  |                          1 |                  |
| New Histology  | Synaptophysin Staining                  | 3.17%            |                                                     | ordinal  |                          2 |                  |
| New Histology  | Chromogranin A Staining                 | 4.76%            |                                                     | none     |                          1 |                  |
| Baseline Char  | Sex                                     | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Age at Diagnosis                        | 0.00%            |                                                     | none     |                          1 |                  |
| Baseline Char  | Smoking                                 | 9.52%            |                                                     | one-hot  |                          2 |                  |
| Baseline Char  | BMI                                     | 1.59%            |                                                     | none     |                          1 |                  |
| Baseline Char  | WHO Perf Stat                           | 1.59%            |                                                     | one-hot  |                          4 | x                |
| Baseline Char  | Co-morbidity                            | 3.17%            | removed (covered by Co-morbidity Severity)          |          |                         NA |                  |
| Baseline Char  | Co-morbidity Severity                   | 3.17%            |                                                     | ordinal  |                          2 |                  |
| Baseline Char  | Date of Birth                           | 0.00%            | removed (covered by Age)                            |          |                         NA |                  |
| Baseline Char  | Date of Diagnosis                       | 0.00%            | removed (date)                                      |          |                         NA |                  |
| Baseline Char  | Loc Adv Resectable Disease              | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Loc Reccurence                          | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Metastatic Disease at Time of Diagnosis | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Date of Metastasis                      | 0.00%            | removed (date)                                      |          |                         NA |                  |
| Baseline Char  | Treatment Intention                     | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Family Member with NET                  | 33.33%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Baseline Char  | Prior Other Cancer                      | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Date of Diagnosis Prior Cancer          | 84.13%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Baseline Char  | Living Alone                            | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | T-stage                                 | 26.98%           | removed (\>25% NA)                                  | ordinal  |                          3 |                  |
| Baseline Char  | N-stage                                 | 4.76%            |                                                     | ordinal  |                          2 |                  |
| Baseline Char  | M-stage                                 | 0.00%            |                                                     | ordinal  |                          1 |                  |
| Baseline Char  | TNM-staging                             | 0.00%            |                                                     | one-hot  |                          1 | x                |
| Baseline Char  | Stage grouped                           | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Mets(Bone)                              | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Mets(Brain)                             | 0.00%            | removed (no variation)                              |          |                         NA |                  |
| Baseline Char  | Mets(LN Distant)                        | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Mets(LN Regional)                       | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Mets(LN Retro)                          | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Mets(LN)                                | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Mets(Liver)                             | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | % Liver Affection                       | 33.33%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Baseline Char  | Mets(Lung)                              | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Mets(Other)                             | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Mets(Skin)                              | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Primary Tumour Resected                 | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Date of PT Resection                    | 71.43%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Baseline Char  | Resection                               | 76.19%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Baseline Char  | Radical Surgery                         | 1.59%            |                                                     | one-hot  |                          1 |                  |
| Baseline Char  | Date of Radical Surgery                 | 92.06%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Baseline Char  | Date of Last Observation                | 0.00%            | removed (date)                                      |          |                         NA |                  |
| Baseline Char  | Time from PET to PT Resection (days)    | 73.02%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Baseline Char  | Time from PET to Metastasis (days)      | 0.00%            |                                                     | none     |                          1 |                  |
| Baseline Char  | Time from PET to Diagnosis (days)       | 0.00%            |                                                     | none     |                          1 |                  |
| Baseline Char  | Time from diag to mets (days)           | 0.00%            | removed (covered by Time to mets \[months\])        |          |                         NA |                  |
| Baseline Char  | Time from diag to mets (months)         | 0.00%            |                                                     | none     |                          1 |                  |
| Treatment      | Time from PET to first treatment (days) | 0.00%            |                                                     | none     |                          1 |                  |
| Treatment      | Chemotherapy Type                       | 0.00%            |                                                     | one-hot  |                          4 |                  |
| Treatment      | Date of First Treatment                 | 0.00%            | removed (date)                                      |          |                         NA |                  |
| Treatment      | Date of Last Treatment                  | 1.59%            | removed (date)                                      |          |                         NA |                  |
| Treatment      | Date of Progression                     | 1.59%            | removed (date)                                      |          |                         NA |                  |
| Treatment      | Duration of Response (Months)           | 9.52%            | removed (date)                                      |          |                         NA |                  |
| Treatment      | Number of Courses                       | 1.59%            |                                                     | none     |                          1 |                  |
| Treatment      | Other Chemotherapy                      | 82.54%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Treatment      | Treatment Stopped                       | 1.59%            |                                                     | one-hot  |                          3 |                  |
| Treatment      | Best Response (RECIST)                  | 0.00%            |                                                     | one-hot  |                          5 |                  |
| Treatment      | Reintroduction with Cisplatin+Etoposide | 0.00%            |                                                     | one-hot  |                          1 |                  |
| Treatment      | Date of First Reintroduction            | 92.06%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Treatment      | Best Response 2 (RECIST)                | 92.06%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Treatment      | Date of Progression                     | 93.65%           | removed (\>25% NA)                                  |          |                         NA |                  |
| Treatment      | Progression                             | 1.59%            |                                                     | one-hot  |                          2 |                  |
