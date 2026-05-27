import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final services = [
      {
        'title': 'Psychiatric Clinic',
        'icon': Icons.medical_services,
        'desc':
        'Our outpatient psychiatric facility provides comprehensive mental health assessment, treatment, and follow-up care in a safe, respectful, and confidential environment. We treat a wide range of mental health conditions including depression, anxiety disorders, bipolar disorder, schizophrenia, stress-related problems, sleep difficulties, trauma-related conditions, and emotional or behavioral concerns.\n\n'
            'Our team is committed to delivering evidence-based, ethical, and high-quality psychiatric care tailored to each individual’s needs. Services include psychiatric consultation, medication management, psychotherapy, counseling, psychoeducation, and ongoing support to help patients achieve better mental well-being and improved quality of life.'
      },
      {
        'title':
        'Inpatient Psychiatric Facility',
        'icon': Icons.psychology,
        'desc':
        'An inpatient psychiatric facility provides a safe, supportive, and structured environment for individuals experiencing severe mental health difficulties. It helps patients who may be struggling with conditions such as severe depression, anxiety, psychosis, bipolar disorder, suicidal thoughts, or emotional crises that require close monitoring and intensive treatment.\n\n'
            'Patients receive comprehensive care from a mental health team that includes psychiatrists, psychologists, medical officers and nurses. Treatment can include medications, psychological support, counseling, crisis management, and rehabilitation planning. The goal of inpatient care is to stabilise symptoms, ensure safety, improve daily functioning, and help patients return to their families and communities with better mental well-being and ongoing support.'
      },
      {
        'title': 'Psychotherapy',
        'icon': Icons.favorite_outline,
        'desc':
        'Psychotherapy is a professional treatment that helps people understand their thoughts, emotions, behaviours, and life challenges in a safe, confidential environment. It can help individuals cope with stress, anxiety, depression, trauma, relationship difficulties, low self-esteem, and other emotional or psychological problems.\n\n'
            'Through supportive conversations and evidence-based techniques, psychotherapy helps people develop healthier coping skills, improve emotional balance, strengthen relationships, and better manage daily life. It aims to promote personal growth, resilience, and long-term mental well-being.'
      },
      {
        'title': 'Pharmacy',
        'icon': Icons.local_pharmacy,
        'desc':
        'Our pharmacy provides high-quality, cost-effective medications, with a strong focus on patient well-being and ethical care. We believe in offering the most suitable treatment options based on medical needs, without influence or pressure from pharmaceutical companies. Our goal is to ensure safe, reliable, and affordable medicines that support better health outcomes for every patient.'
      },
      {
        'title':
        'Electroconvulsive Therapy (ECT)',
        'icon': Icons.bolt,
        'desc':
        'ECT is a safe and effective medical treatment used mainly for severe depression, certain psychotic illnesses, severe mania, and conditions where rapid improvement is needed.\n\n'
            'During ECT, the patient is given short general anesthesia and muscle relaxation, then a carefully controlled electrical stimulus is applied to the brain to produce a brief therapeutic seizure. The procedure usually lasts only a few minutes, and patients are closely monitored throughout.\n\n'
            'ECT can be especially helpful when medications are not working well, cannot be tolerated, or when symptoms are severe, such as suicidal thoughts, refusal to eat, severe agitation, or catatonia.\n\n'
            'Common temporary side effects may include headache, body aches, or short-term memory difficulties, which usually improve over time. Modern ECT is performed under anesthesia and is much safer and more comfortable than many people imagine from old portrayals in movies.'
      },
      {
        'title': 'Laboratory',
        'icon': Icons.science,
        'desc':
        'We provide convenient laboratory services through collaboration with a high-quality standard diagnostic laboratory. Our sample collection unit helps patients access necessary blood tests and investigations in a comfortable and hassle-free manner, ensuring reliable results and coordinated care as part of their treatment journey.'
      },
      {
        'title': 'Others',
        'icon': Icons.groups_2,
        'desc':
        'In addition to mental health services, our facility also provides access to dedicated care from other medical specialists including dermatologists, physiotherapists, cardiologists, and physicians. Through a multidisciplinary approach, we aim to support both physical and mental well-being by offering comprehensive, patient-centered healthcare services under one platform.\n\n'
            'Our specialists are committed to delivering evidence-based, ethical, and high-quality medical care tailored to each patient’s individual needs. This collaborative approach helps ensure better overall health outcomes, continuity of care, and improved quality of life for our patients.'
      },
    ];

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text(
          'Our Services',
        ),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding:
        const EdgeInsets.all(16),
        itemCount: services.length,

        itemBuilder:
            (context, index) {

          final service =
          services[index];

          return Card(
            elevation: 0,
            margin:
            const EdgeInsets.only(
              bottom: 14,
            ),

            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                24,
              ),
            ),

            color: isDark
                ? const Color(
                0xFF1F2937)
                : Colors.white,

            child: Theme(
              data: Theme.of(context)
                  .copyWith(
                dividerColor:
                Colors.transparent,
              ),

              child: ExpansionTile(
                tilePadding:
                const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),

                collapsedShape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    24,
                  ),
                ),

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    24,
                  ),
                ),

                leading:
                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                  const Color(
                    0xFF0F766E,
                  ),
                  child: Icon(
                    service['icon']
                    as IconData,
                    color:
                    Colors.white,
                  ),
                ),

                title: Text(
                  service['title']
                  as String,
                  style:
                  TextStyle(
                    fontWeight:
                    FontWeight.bold,
                    fontSize: 16,
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),

                subtitle: Text(
                  'Tap to learn more',
                  style: TextStyle(
                    color: isDark
                        ? Colors.grey[400]
                        : Colors.grey[
                    700],
                  ),
                ),

                children: [
                  Padding(
                    padding:
                    const EdgeInsets
                        .fromLTRB(
                      20,
                      0,
                      20,
                      22,
                    ),

                    child: Text(
                      service['desc']
                      as String,

                      style:
                      TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        color: isDark
                            ? Colors.white
                            : Colors
                            .black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}