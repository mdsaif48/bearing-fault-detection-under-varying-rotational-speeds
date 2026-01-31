
# Bearing Fault Detection Using Vibration Analysis

# PROJECT OVERVIEW: 
This project focuses on condition monitoring of rolling element bearings using vibration signal analysis. Time-domain vibration signals are processed and analyzed to extract statistical features, which are then used to classify bearing health conditions such as healthy, inner race fault, and outer race fault using machine learning techniques.

The work emphasizes signal processing and fault diagnosis, not full predictive maintenance deployment.
# WORKFLOW 
[!image alt](https://github.com/mdsaif48/bearing-fault-detection-under-varying-rotational-speeds/blob/2d6d7749e5e39d4edd6088262bf78d394f64aeaa/pipeline/workflow.png)


# Method overview :
1. Data Acquisition
Vibration signals collected from bearing test setups under different fault conditions.

2. Signal Preprocessing
Detrending, normalization, and high-pass filtering applied to remove noise and low-frequency components.

3. Feature Extraction
Time-domain statistical features such as RMS, standard deviation, skewness, and kurtosis extracted from vibration signals.

4. Model Training
A Random Forest classifier trained to distinguish between healthy and faulty bearing conditions.

5. Evaluation
Classification performance evaluated using hold-out validation and confusion-based metrics.


# Limitations
1. Based on laboratory data, not real industrial operating conditions

2. No Remaining Useful Life (RUL) estimation or online monitoring system implemented

3. Model performance depends heavily on feature selection

# Future scope

1. Incorporation of FFT and envelope spectrum features

2. Exploration of time-frequency methods (STFT, wavelets)

3. Extension to degradation tracking and RUL estimation

4. Validation on real-world rotating machinery datasets

5. Integration with embedded data acquisition systems
 
# References 

[Mendeley Data](https://data.mendeley.com/datasets/v43hmbwxpm/1)

