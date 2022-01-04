import UIKit
import RxSwift

class SplashViewConroller: BaseViewController {
    
    weak var coordinator: MainCoordinator?
    
    private let splashView = SplashView()
    private let viewModel = SplashViewModel(
        userDefaults: UserDefaultsUtil()
    )
    
    static func instance() -> SplashViewConroller {
        return SplashViewConroller.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* RxViewController
         self.rx.viewDidLoad
         .subscribe(onNext: {
         print("viewDidLoad 🎉")
         })
         */
        self.navigationController?.isNavigationBarHidden = true
        self.viewModel.input.viewDidLoad.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func bindViewModel() {
        /*
         self.rx.viewDidLoad
         .subscribe(onNext: {
         print("viewDidLoad 🎉")
         }) */
        
        self.viewModel.input.viewDidLoad
            .subscribe { _ in
                self.viewModel.hasToken()
            }
            .disposed(by: disposeBag)

        self.splashView.signInButton.rx.tap
            .bind(to: self.viewModel.input.tapSignInButton)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToSignIn
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToSignIn)
            .disposed(by: disposeBag)

        self.viewModel.output.goToMain
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToMain)
            .disposed(by: disposeBag)
    }
    
    
    // MARK: 네비게이터로 분리 하기
    func goToMain() {
        self.coordinator?.goToMain()
    }
    
    func goToSignIn() {
        self.coordinator?.goToSigIn()
    }
    
}
