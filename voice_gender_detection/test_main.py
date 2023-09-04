if __name__ == "__main__":
    from test_utils import record_to_file, extract_feature, create_model
    import argparse
    import os

    os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"
    parser = argparse.ArgumentParser(description="""Gender recognition script, this will load the model you trained, 
                                    and perform inference on a sample you provide (either using your voice or a file)""")
    parser.add_argument("-f", "--file", help="The path to the file, preferred to be in WAV format")
    args = parser.parse_args()
    file = args.file
    # construct the model
    model = create_model(168)
    # load the saved/trained weights
    model.load_weights("models/model.h5")
    if not file or not os.path.isfile(file):
        # if file not provided, or it doesn't exist, use your voice
        print("Please talk")
        # put the file name here
        file = "test.wav"
        # record the file (start talking)
        record_to_file(file)
    # extract features and reshape it
    features = extract_feature(file, mfcc=True, mel=True).reshape(1, -1)
    # predict the gender!
    male_prob = model.predict(features)[0][0]
    female_prob = 1 - male_prob
    gender = "male" if male_prob > female_prob else "female"
    # show the result!
    print("Result:", gender)
    print(f"Probabilities:     Male: {male_prob*100:.2f}%    Female: {female_prob*100:.2f}%")