CREATE DATABASE IF NOT EXISTS rehably_db;
USE rehably_db;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('PATIENT','DOCTOR') NOT NULL,
    doctor_id VARCHAR(20) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_username (username),
    KEY idx_users_doctor_id (doctor_id)
);

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id VARCHAR(20) NOT NULL,
    name VARCHAR(150) NOT NULL,
    specialty VARCHAR(150) NOT NULL,
    description TEXT NULL,
    qualifications VARCHAR(500) NULL,
    PRIMARY KEY (doctor_id),
    KEY idx_doctors_specialty (specialty)
);

CREATE TABLE IF NOT EXISTS doctor_tags (
    doctor_id VARCHAR(20) NOT NULL,
    tag VARCHAR(100) NOT NULL,
    PRIMARY KEY (doctor_id, tag),
    KEY idx_doctor_tags_tag (tag),
    CONSTRAINT fk_doctor_tags_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS appointment_requests (
    request_id BIGINT NOT NULL AUTO_INCREMENT,
    patient_id BIGINT NOT NULL,
    doctor_id VARCHAR(20) NOT NULL,
    patient_name VARCHAR(150) NOT NULL,
    doctor_name VARCHAR(150) NOT NULL,
    specialty VARCHAR(150) NOT NULL,
    consultation_reason TEXT NOT NULL,
    preferred_date DATE NULL,
    preferred_time TIME NULL,
    notes TEXT NULL,
    submitted_at DATETIME NOT NULL,
    status ENUM('PENDING','ACCEPTED','DECLINED','COMPLETED') NOT NULL DEFAULT 'PENDING',
    PRIMARY KEY (request_id),
    KEY idx_appointment_patient (patient_id),
    KEY idx_appointment_doctor (doctor_id),
    KEY idx_appointment_status (status),
    CONSTRAINT fk_requests_patient FOREIGN KEY (patient_id) REFERENCES users(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_requests_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS resources (
    id BIGINT NOT NULL AUTO_INCREMENT,
    resource_type VARCHAR(50) NOT NULL,
    category VARCHAR(150) NOT NULL,
    name VARCHAR(200) NOT NULL,
    body_area VARCHAR(150) NULL,
    purpose TEXT NULL,
    equipment_required VARCHAR(500) NULL,
    instructions TEXT NULL,
    difficulty VARCHAR(50) NULL,
    safety_notes TEXT NULL,
    PRIMARY KEY (id),
    KEY idx_resources_type_category (resource_type, category),
    KEY idx_resources_name (name)
);

INSERT INTO users (username, password, role, doctor_id)
SELECT 'patient', '$2a$10$yZJgXKSYiqX/ZTgnEVE29Og9xSE4YC6KI/2C9fiQdJaN0mIcDkZg.', 'PATIENT', NULL
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'patient');

INSERT INTO users (username, password, role, doctor_id)
SELECT 'doctor', '$2a$10$zc7XL38uu286uxifAIxvWOFx8y5xY8jokDPueejNye6GnX3p5FYya', 'DOCTOR', 'DOC001'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'doctor');

INSERT INTO doctors (doctor_id, name, specialty, description, qualifications)
VALUES
('DOC001','Dr. Aarav Mehta','Orthopaedics','Specializes in fracture care, joint mobility, and post-surgical recovery for active adults.','MBBS, MS (Orthopaedics)'),
('DOC002','Dr. Naina Kapoor','Orthopaedics','Helps patients return to strength after sports injuries, tendon strains and bone trauma.','MBBS, DNB Orthopaedics'),
('DOC003','Dr. Rohan Iyer','Orthopaedics','Focused on knee, hip and lower-limb rehabilitation using activity-based care plans.','MBBS, MS Orthopaedics'),
('DOC004','Dr. Megha Arora','Orthopaedics','Treats arthritis, posture issues and musculoskeletal pain with a whole-body approach.','MBBS, MS (Ortho)'),
('DOC005','Dr. Kabir Verma','Orthopaedics','Experience in trauma recovery, tendon repair and long-term mobility planning.','MBBS, DNB Orthopaedics'),
('DOC006','Dr. Sana Khanna','Orthopaedics','Supports patients with shoulder instability, elbow pain and movement restoration.','MBBS, MS Orthopaedics'),
('DOC007','Dr. Vihaan Shah','Orthopaedics','Works with bone healing, gait correction and lower-limb functional training.','MBBS, DNB Orthopaedics'),
('DOC008','Dr. Alisha Sen','Orthopaedics','Provides care for spinal alignment, chronic joint pain and post-injury recovery.','MBBS, MS Orthopaedics'),
('DOC009','Dr. Arjun Das','Orthopaedics','Specializes in reconstruction, mobility planning and strength restoration after trauma.','MBBS, DNB Orthopaedics'),
('DOC010','Dr. Pooja Nair','Neurology','Treats movement disorders, balance concerns and neurological rehabilitation with a patient-first plan.','MBBS, MD Neurology'),
('DOC011','Dr. Ritesh Kulkarni','Neurology','Addresses posture, gait change and nerve-related pain through targeted therapy strategies.','MBBS, MD Neurology'),
('DOC012','Dr. Isha Gupta','Neurology','Supports recovery from stroke, nerve injury and everyday movement limitations.','MBBS, DNB Neurology'),
('DOC013','Dr. Vedant Joshi','Neurology','Develops individualized plans for balance, fatigue and functional movement training.','MBBS, MD Neurology'),
('DOC014','Dr. Tanvi Sethi','Sports Rehabilitation','Creates return-to-play programs for athletes and active patients after injury.','BPT, MPT Sports Rehab'),
('DOC015','Dr. Dev Malhotra','Sports Rehabilitation','Focuses on muscle recovery, tendon support, and performance-safe movement retraining.','BPT, MPT Sports Rehab'),
('DOC016','Dr. Simran Bhatia','Sports Rehabilitation','Works on rehabilitation plans for overuse injuries, ligament strain and athlete recovery.','BPT, MPT Sports Therapy'),
('DOC017','Dr. Yash Mahajan','Sports Rehabilitation','Helps patients recover movement confidence through progressive strength and agility work.','BPT, MPT Sports Rehab'),
('DOC018','Dr. Meher Chawla','Paediatric Therapy','Provides child-friendly rehabilitation programs for mobility, coordination and developmental movement.','BPT, MPT Paediatric Therapy'),
('DOC019','Dr. Aditya Rao','Paediatric Therapy','Supports children with posture, balance and motor development milestones.','BPT, MPT Paediatric Rehab'),
('DOC020','Dr. Khushi Menon','Paediatric Therapy','Specializes in early rehabilitation and playful movement strategies for growing children.','BPT, MPT Paediatric Therapy'),
('DOC021','Dr. Pranav Nanda','Geriatric Care','Focuses on mobility support, balance guidance and home-based recovery for older adults.','MBBS, MD Geriatrics'),
('DOC022','Dr. Divya Iyer','Geriatric Care','Creates safe rehab plans for aging adults who want to stay mobile and independent.','MBBS, MD Geriatrics'),
('DOC023','Dr. Anika Sharma','Cardio Respiratory Rehabilitation','Helps patients improve breathing capacity, stamina and confidence after respiratory challenges.','MBBS, MPT Cardio Rehab'),
('DOC024','Dr. Karan Bedi','Cardio Respiratory Rehabilitation','Supports endurance recovery, posture and breathing training for daily function.','MBBS, MPT Cardio Rehab'),
('DOC025','Dr. Neha Suri','Women\'s Health Physiotherapy','Supports pelvic floor care, pain management and movement recovery with a gentle, evidence-based approach.','BPT, MPT Women\'s Health');

INSERT INTO doctor_tags (doctor_id, tag) VALUES
('DOC001','joint care'),('DOC001','fracture recovery'),('DOC001','mobility'),('DOC001','rehabilitation'),
('DOC002','sports recovery'),('DOC002','joint care'),('DOC002','mobility'),('DOC002','posture'),
('DOC003','knee care'),('DOC003','hip mobility'),('DOC003','strength'),('DOC003','rehabilitation'),
('DOC004','joint care'),('DOC004','pain management'),('DOC004','mobility'),('DOC004','posture correction'),
('DOC005','fracture recovery'),('DOC005','mobility'),('DOC005','orthopedic rehab'),('DOC005','strength'),
('DOC006','shoulder care'),('DOC006','mobility'),('DOC006','joint recovery'),('DOC006','strength'),
('DOC007','gait correction'),('DOC007','joint care'),('DOC007','mobility'),('DOC007','rehabilitation'),
('DOC008','spinal care'),('DOC008','pain management'),('DOC008','mobility'),('DOC008','joint care'),
('DOC009','fracture recovery'),('DOC009','strength'),('DOC009','mobility'),('DOC009','rehabilitation'),
('DOC010','neurological rehab'),('DOC010','balance'),('DOC010','mobility'),('DOC010','coordination'),
('DOC011','nerve care'),('DOC011','gait'),('DOC011','movement'),('DOC011','rehabilitation'),
('DOC012','stroke recovery'),('DOC012','coordination'),('DOC012','mobility'),('DOC012','posture'),
('DOC013','balance'),('DOC013','mobility'),('DOC013','functional movement'),('DOC013','neurological rehab'),
('DOC014','sports rehabilitation'),('DOC014','conditioning'),('DOC014','strength'),('DOC014','mobility'),
('DOC015','sports rehab'),('DOC015','tendon care'),('DOC015','strength'),('DOC015','mobility'),
('DOC016','sports therapy'),('DOC016','injury rehab'),('DOC016','mobility'),('DOC016','strength'),
('DOC017','agility'),('DOC017','strength'),('DOC017','conditioning'),('DOC017','injury recovery'),
('DOC018','child mobility'),('DOC018','developmental movement'),('DOC018','play-based therapy'),('DOC018','coordination'),
('DOC019','child mobility'),('DOC019','motor skills'),('DOC019','posture'),('DOC019','movement'),
('DOC020','child mobility'),('DOC020','developmental movement'),('DOC020','play therapy'),('DOC020','coordination'),
('DOC021','geriatric care'),('DOC021','balance'),('DOC021','mobility'),('DOC021','fall prevention'),
('DOC022','fall prevention'),('DOC022','mobility'),('DOC022','balance'),('DOC022','independence'),
('DOC023','breath control'),('DOC023','stamina'),('DOC023','cardio rehab'),('DOC023','mobility'),
('DOC024','breathing'),('DOC024','stamina'),('DOC024','posture'),('DOC024','mobility'),
('DOC025','pelvic health'),('DOC025','pain management'),('DOC025','mobility'),('DOC025','core strength');

INSERT INTO resources (resource_type, category, name, body_area, purpose, equipment_required, instructions, difficulty, safety_notes)
VALUES
('EXERCISE','Orthopaedic rehabilitation','Quadriceps Strengthening','Knee','Improve knee stability and support daily walking after injury.','Resistance band or loop','Sit with the knee bent and straighten the leg slowly, holding for three seconds before lowering.','Beginner','Stop if pain sharpens or swelling increases.'),
('EXERCISE','Orthopaedic rehabilitation','Glute Bridge','Hip','Activate the glutes to support lower-body recovery and posture.','Yoga mat','Lie on your back, bend knees, raise hips and hold briefly before lowering.','Beginner','Avoid arching the lower back during the lift.'),
('EXERCISE','Orthopaedic rehabilitation','Heel Slides','Knee','Restore smooth knee bending without excessive strain.','Yoga mat','Lie flat and gently slide the heel away from the body, then return to start.','Beginner','Move slowly; do not force the range of motion.'),
('EXERCISE','Orthopaedic rehabilitation','Straight Leg Raise','Knee','Improve hip and thigh control while protecting the knee.','Yoga mat','Lie on your back, hold the leg straight and lift a few inches before lowering slowly.','Beginner','Do not twist the pelvis or lift too high.'),
('EXERCISE','Orthopaedic rehabilitation','Mini Squat','Hip and knee','Build strength in the legs while improving standing control.','Chair or wall','Sit lightly and rise to standing without pushing through pain.','Beginner','Keep knees tracking over toes and avoid deep flexion if painful.'),
('EXERCISE','Knee and hip mobility','Seated Knee Flexion','Knee','Ease stiffness and improve bend in the knee joint.','Chair','Sit upright and slowly bend the knee as far as comfortable before straightening.','Beginner','Move within a pain-free range.'),
('EXERCISE','Knee and hip mobility','Hip Circles','Hip','Increase mobility in the hips and reduce tension after inactivity.','Chair or wall','Stand tall and make controlled circles with the hips in both directions.','Beginner','Keep the movement small and slow.'),
('EXERCISE','Knee and hip mobility','Ankle Pumps','Ankle and lower leg','Encourage circulation and maintain ankle motion after surgery or rest.','None','Move the foot up and down, alternating gently while seated or reclining.','Beginner','Stop if there is sharp calf pain or heaviness.'),
('EXERCISE','Knee and hip mobility','Hamstring Stretch','Hamstrings','Improve flexibility and reduce tightness around the back of the leg.','Yoga mat','Sit tall and hinge forward gently from the hips while keeping the back long.','Beginner','Avoid rounding the spine.'),
('EXERCISE','Knee and hip mobility','Standing Hip Flexor Stretch','Hip','Open the front of the hip to improve gait and comfort.','Wall or chair','Stand in a split stance and gently shift weight forward until a stretch is felt.','Beginner','Keep the pelvis level and do not force the stretch.'),
('EXERCISE','Shoulder, wrist and arm rehabilitation','Pendulum Swing','Shoulder','Promote shoulder movement without heavy loading after stiffness or limited mobility.','None','Lean forward and sway the arm gently in a circular motion.','Beginner','Keep the movement relaxed and controlled.'),
('EXERCISE','Shoulder, wrist and arm rehabilitation','Wrist Flexor Stretch','Wrist','Reduce tightness in the forearm and improve hand movement.','None','Extend the arm and gently pull the fingers back with the other hand.','Beginner','Stop if tingling or numbness begins.'),
('EXERCISE','Shoulder, wrist and arm rehabilitation','Arm Reach','Shoulder and upper back','Improve shoulder range of motion and posture.','Wall or mirror','Raise the arm gradually to shoulder height and return to the start position.','Beginner','Keep the shoulder blades gently down.'),
('EXERCISE','Shoulder, wrist and arm rehabilitation','Band Pull Apart','Upper back and shoulder','Support posture and upper-back activation.','Resistance band','Hold the band at chest height and pull the hands apart without shrugging.','Intermediate','Avoid excessive neck tension.'),
('EXERCISE','Shoulder, wrist and arm rehabilitation','Forearm Pronation Drill','Wrist and forearm','Improve rotation and control of the forearm.','None or light weight','Rest elbow by side and turn palm up and down slowly.','Beginner','Movements should remain smooth and pain-free.'),
('EXERCISE','Back care and posture','Cat-Cow Mobility','Spine','Encourage spinal movement and reduce stiffness in the neck and back.','Yoga mat','Alternate arching and rounding the back while moving slowly through the spine.','Beginner','Move gently and keep breathing steady.'),
('EXERCISE','Back care and posture','Thoracic Extension','Upper back','Improve upper-back mobility and posture support.','Chair or foam roller','Sit tall and gently extend the upper back while opening the chest.','Beginner','Avoid forcing the neck backward.'),
('EXERCISE','Back care and posture','Wall Slide','Upper back and shoulder','Encourage postural positioning and shoulder range of motion.','Wall','Press the back of the arms against the wall and slide upward slowly.','Beginner','Keep the ribs relaxed and the neck long.'),
('EXERCISE','Back care and posture','Prone Press-Up','Lower back','Support gentle spinal extension and improve standing function.','Yoga mat','Lie on the stomach and lift the chest slightly, then lower back down.','Intermediate','Stop if low-back pain increases or radiates down the leg.'),
('EXERCISE','Physiotherapy and flexibility','Calf Stretch','Lower leg','Ease calf tension and support ankle mobility.','Wall','Lean forward against a wall with one leg back and heel down.','Beginner','Keep the back leg straight and heel grounded.'),
('EXERCISE','Physiotherapy and flexibility','Seated Hamstring Reach','Hamstrings','Improve lower-limb flexibility for walking and standing.','Chair','Sit on the edge of a chair and reach toward the toes with a long back.','Beginner','Avoid rounding the lower back.'),
('EXERCISE','Physiotherapy and flexibility','Chest Opener','Chest and shoulders','Reduce tightness from desk posture or scrolling habits.','None','Open the arms to the sides and gently raise them while drawing shoulder blades together.','Beginner','Keep the rib cage relaxed.'),
('EXERCISE','Strength and resistance exercises','Sit-to-Stand','Legs and hips','Improve leg power, standing control and general function.','Chair','Stand from a seated position using the legs and return slowly to sit.','Beginner','Use a chair height that allows pain-free movement.'),
('EXERCISE','Strength and resistance exercises','Step-Up','Legs and hips','Build lower-body strength for walking and stair safety.','Low step or bench','Step onto a stable surface and lower with control.','Intermediate','Use a low, stable step to reduce fall risk.'),
('EXERCISE','Strength and resistance exercises','Banded Row','Upper back','Strengthen posture-support muscles and shoulder stability.','Resistance band','Pull the band toward the torso while keeping shoulders down and back.','Beginner','Move at a slow pace and avoid shrugging.'),
('EXERCISE','Strength and resistance exercises','Wall Push-Up','Chest and shoulder','Build upper-body strength safely for early rehab.','Wall','Stand facing the wall and press forward gently before returning to the start.','Beginner','Keep the body in a straight line.'),
('EXERCISE','Balance, coordination and mobility','Single-Leg Stand','Balance','Improve steadiness and lower-body control.','Chair or wall','Stand with one leg lifted slightly and maintain balance while keeping the torso tall.','Beginner','Use support if needed to stay safe.'),
('EXERCISE','Balance, coordination and mobility','Heel-to-Toe Walk','Balance and posture','Build coordination and reduce fall risk.','Wall or hallway','Walk slowly, placing one foot directly in front of the other.','Intermediate','Perform with support nearby if unsure.'),
('EXERCISE','Balance, coordination and mobility','Marching in Place','Balance and lower body','Improve coordination and leg control in a simple, low-impact way.','None or chair','Lift knees alternately while keeping the core steady and posture tall.','Beginner','Keep movements gentle and controlled.'),
('EXERCISE','Balance, coordination and mobility','Weight Shift','Balance','Develop controlled side-to-side weight transfer for standing safety.','Wall or chair','Shift weight slowly from one foot to the other without losing balance.','Beginner','Keep the shoulders relaxed and movement slow.'),
('EXERCISE','Paediatric rehabilitation and child-friendly movement activities','Animal Walks','Whole body','Encourage coordination, balance and playful movement in children.','Open floor space','Walk like a bear, crab or frog while following simple prompts.','Beginner','Keep the activity safe and supervised for younger children.'),
('EXERCISE','Paediatric rehabilitation and child-friendly movement activities','Obstacle Steps','Lower body coordination','Build confidence with stepping, balance and attention.','Low cushions or markers','Step over markers or around safe obstacles in a playful sequence.','Beginner','Use supervision and safe spacing.'),
('EXERCISE','Paediatric rehabilitation and child-friendly movement activities','Ball Toss and Catch','Upper body and coordination','Improve hand-eye coordination and upper-limb movement.','Soft ball','Toss and catch with a slow rhythm and gradual distance increase.','Beginner','Use a soft ball and keep the range comfortable.'),
('EXERCISE','Paediatric rehabilitation and child-friendly movement activities','Balance Beam Steps','Balance','Support steady foot placement and postural control.','Low beam or taped line','Step slowly along a line or beam while maintaining balance.','Intermediate','Ensure support is available for safety.'),
('FIRST_AID','Basic first-aid and injury-support information','RICE for Mild Injury','General','Support soft tissue symptoms after a minor strain or sprain.','Ice pack, elastic wrap, rest','Rest the area, apply ice, compress gently and elevate as needed.','General','This is general advice; seek professional assessment if symptoms worsen or you cannot bear weight.'),
('FIRST_AID','Basic first-aid and injury-support information','Cooling and swelling management','General','Calm acute inflammation and relieve discomfort after a recent injury.','Cold pack, cloth','Wrap ice in a cloth and apply for short intervals, taking breaks between applications.','General','Do not place ice directly on skin and stop if numbness develops.'),
('FIRST_AID','Basic first-aid and injury-support information','Protective Rest Guidance','General','Reduce stress on an injured area while recovery begins.','Support bandage or brace','Avoid unnecessary strain and follow activity modifications suggested by a healthcare professional.','General','Professional assessment is recommended if there is severe pain, swelling or instability.'),
('FIRST_AID','Basic first-aid and injury-support information','When to seek urgent care','General','Identify warning signs requiring further assessment beyond home care.','Professional advice','Seek prompt evaluation for severe pain, repeated swelling, inability to bear weight or sudden numbness.','General','This information is educational only and not a substitute for professional medical review.'),
('EQUIPMENT','Resistance and strengthening equipment','Resistance Band','Upper and lower body','Adds light resistance to strengthen muscles safely at home.','Band','Wrap around hands or feet and perform slow controlled movements.','Beginner','Choose a resistant band that does not cause sharp pain during use.'),
('EQUIPMENT','Resistance and strengthening equipment','Light Dumbbells','Upper body and lower body','Support controlled strengthening and rehabilitation planning.','Dumbbells','Use low weight with slow repetitions and smooth motion.','Beginner','Keep posture tall and avoid jerky movements.'),
('EQUIPMENT','Resistance and strengthening equipment','Therapy Putty','Hand and wrist','Improves grip strength and coordination after hand or wrist conditions.','Putty','Squeeze, roll and stretch the putty using slow, deliberate movements.','Beginner','Stop if pain or tingling appears.'),
('EQUIPMENT','Mobility aids','Walking Cane','Lower body mobility','Provides stability and support during standing or walking.','Cane','Use with the stronger side to help maintain balance while walking.','Beginner','Adjust height to a comfortable level and inspect rubber tip regularly.'),
('EQUIPMENT','Mobility aids','Walking Stick','Balance and posture','Adds confidence during short walks and recovery periods.','Stick','Hold with a comfortable grip and keep the movement smooth and controlled.','Beginner','Use on stable surfaces and avoid wet floors.'),
('EQUIPMENT','Mobility aids','Foam Roller','Muscle recovery','Helps reduce tightness and improve tissue mobility after exercise.','Foam roller','Roll slowly over tight areas while keeping breathing relaxed.','Beginner','Avoid rolling over bruised or acutely inflamed areas.'),
('EQUIPMENT','Balance and coordination equipment','Balance Pad','Balance','Adds gentle challenge for standing and stability training.','Balance pad','Stand on the pad and keep weight evenly distributed.','Beginner','Use near a wall or support surface for safety.'),
('EQUIPMENT','Balance and coordination equipment','Balance Board','Balance','Improves weight shift, coordination and postural control.','Balance board','Shift slowly from side to side while maintaining steady posture.','Intermediate','Avoid using if the surface is slippery or you have significant dizziness.'),
('EQUIPMENT','Balance and coordination equipment','Soft Ball','Coordination and upper body','Supports hand-eye coordination and light movement practice.','Soft ball','Toss, catch or pass with controlled movement.','Beginner','Use in a clear area to reduce trip risk.'),
('EQUIPMENT','Orthopaedic support and recovery aids','Knee Brace','Knee','Provides support and confidence during healing or wear-related discomfort.','Brace','Fit snugly according to size guidance and follow comfort limits.','Beginner','Remove if there is numbness, skin irritation or severe discomfort.'),
('EQUIPMENT','Orthopaedic support and recovery aids','Ankle Support Wrap','Ankle','Adds stability and limits excessive movement during recovery.','Wrap','Apply with even pressure and adjust to avoid tightness.','Beginner','Do not wrap so tightly that circulation is affected.'),
('EQUIPMENT','Orthopaedic support and recovery aids','Shoulder Sling','Shoulder','Supports the arm and limits strain during recovery.','Sling','Keep the sling adjusted to support the forearm and maintain alignment.','Beginner','Professional instruction is helpful for proper fitting.'),
('EQUIPMENT','Physiotherapy equipment','Exercise Mat','General','Provides support and cushioning for floor-based therapy routines.','Exercise mat','Place on a stable, flat surface before any floor work.','Beginner','Keep the area clear of tripping hazards.'),
('EQUIPMENT','Physiotherapy equipment','Stability Ball','Core and balance','Improves trunk control and postural stability.','Stability ball','Use with support or under supervision in a safe upright position.','Intermediate','Stop if there is dizziness or loss of control.'),
('EQUIPMENT','Physiotherapy equipment','Elastic Band Set','Strength and mobility','Provides graded resistance for repeated rehab exercises.','Bands','Select a light resistance level for early exercise progression.','Beginner','Inspect for wear before use.'),
('EQUIPMENT','Paediatric therapy equipment','Therapy Balls','Children','Encourages movement and balance through playful activity.','Therapy ball','Use under supervision with safe floor spacing.','Beginner','Check for firm floor support before use.'),
('EQUIPMENT','Paediatric therapy equipment','Balance Beam','Children','Supports stepping, coordination, stability and confidence building.','Balance beam','Follow slow movement prompts and keep a clear area around the beam.','Beginner','Children should be supervised during each session.'),
('EQUIPMENT','Paediatric therapy equipment','Sensory Cushion','Children','Improves posture and sensory feedback while encouraging playfully guided movement.','Cushion','Place under the child during seated or floor-based activities.','Beginner','Inspect for wear and keep usage brief and supervised.'),
('EQUIPMENT','Basic first-aid and recovery supplies','Cold Compress Pack','General','Helps reduce heat and swelling after a minor injury.','Cold compress','Apply in short intervals with cloth protection to the skin.','Beginner','Do not place directly on the skin or sleep with it on.'),
('EQUIPMENT','Basic first-aid and recovery supplies','Compression Bandage','General','Offers light support to reduce swelling and limit motion after minor strain.','Compression bandage','Wrap in a comfortable, even layer and recheck for tightness.','Beginner','Do not wrap too tightly; monitor skin and circulation.'),
('EQUIPMENT','Basic first-aid and recovery supplies','First-Aid Kit','General','Keeps essential support supplies ready for minor injury care and home recovery.','First-aid kit','Store in a clean dry place; check contents before travel or exercise sessions.','Beginner','Replace used items and keep supplies up to date.');
