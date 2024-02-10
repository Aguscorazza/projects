import cv2
import cvzone
from cvzone.HandTrackingModule import HandDetector
import time
from RPS import check_rps_result, Action
from RPS_model import MarkovChainPredictor

cap = cv2.VideoCapture(0)
# Set Width and Height properties
cap.set(3, 640)
cap.set(4, 480)

detector = HandDetector(maxHands=1)
model = MarkovChainPredictor(order=2, smoothing_parameter=0.1, decay_factor=0.9)

timer = 0
stateResult = False
startGame = False
scores = [0, 0]  # AI - Player
history = []
sym_to_i = {'R': 1, 'P': 2, 'S': 3}
i_to_sym = {1: 'R', 2: 'P', 3: 'S'}

while True:
    imgBG = cv2.imread("../img/BG.png")

    success, img = cap.read()
    # Scale down the image to the same height as the background player rectangle
    imgScaled = cv2.resize(img, (0, 0), None, 0.875, 0.875)

    # Crop the image from the sides to fit perfectly the player rectangle
    imgScaled = imgScaled[:, 80:480]

    hands, img = detector.findHands(imgScaled, draw=True, flipType=True)

    if startGame:
        if stateResult is False:
            timer = time.time() - initialTime
            cv2.putText(imgBG, str(int(timer)), (605, 435), cv2.FONT_HERSHEY_PLAIN, 6, (255, 0, 255), 4)

            if timer > 3:
                stateResult = True
                timer = 0

                if hands:
                    hand = hands[0]
                    fingers = detector.fingersUp(hand)
                    #print(fingers)
                    if fingers == [0, 0, 0, 0, 0]:  # rock
                        playerMove = 1
                    elif fingers == [1, 1, 1, 1, 1]:  # paper
                        playerMove = 2
                    elif fingers == [0, 1, 1, 0, 0]: # scissors
                        playerMove = 3
                    else:
                        playerMove = 1

                    playerMove = Action(playerMove)

                    model.update_matrix(history)

                    computerMove = model.predict(history)
                    history.append(i_to_sym[playerMove.value])
                    #print(history)

                    imgAI = cv2.imread(f"../img/{sym_to_i[computerMove]}.png", cv2.IMREAD_UNCHANGED)

                    round_result = check_rps_result(playerMove, Action(sym_to_i[computerMove]))
                    if round_result == 1:
                        scores[1] += 1
                    elif round_result == 0:
                        scores[0] += 1

    # Include camera image in the background image
    imgBG[234:654, 794:1194] = imgScaled

    if stateResult:
        imgBG = cvzone.overlayPNG(imgBG, imgAI, (149, 310))

    cv2.putText(imgBG, str(scores[0]), (410, 215), cv2.FONT_HERSHEY_PLAIN, 4, (255, 255, 255), 6)
    cv2.putText(imgBG, str(scores[1]), (1112, 215), cv2.FONT_HERSHEY_PLAIN, 4, (255, 255, 255), 6)

    cv2.imshow("Image", imgBG)
    key = cv2.waitKey(1)

    if key == ord("s"):
        startGame = True
        initialTime = time.time()
        stateResult = False
