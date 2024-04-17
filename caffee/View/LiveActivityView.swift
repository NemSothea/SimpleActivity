//
//  LiveActivityView.swift
//  SimpleActivity
//
//  Created by MobileR&D-Sothea007 on 2/4/24.
//

import SwiftUI
import WidgetKit

// MARK: - View LiveActivity
struct LiveActivityView: View {
    // Variable
    let context     : OrderAttributes.ContentState
    let statusType  : OrderAttributes
    
    var body: some View {
        let status = context.status
        
        ZStack {
            RoundedRectangle(cornerRadius: 15, style : .continuous)
                .fill(Color.white)
            
            VStack {
                HeaderView(statusType:statusType)
                ButtonView(status: status)
            }
            .padding(15)
        }
        
        // Case Lanscape
#warning("Should check case Lanscape")
        
    }
    
    @ViewBuilder
    func HeaderView(statusType: OrderAttributes) -> some View {
        HStack {
            Image("wecafe")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
            VStack (alignment: .leading, spacing: -5) {
                
                Text("Order in \(context.status.rawValue)").bold()
                
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(context.description)
                
                    .font(.caption)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .center, spacing: 5 ) {
                HStack {
                    ForEach(Array(["cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill"].enumerated()), id: \.element)  { index , image in
                        ZStack {
                            VStack {
                                Image(systemName:image)
                                    .font(.system(size: 15))
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.purple)
                                    .frame(width: 20, height: 20)
                                    .background(
                                        Circle()
                                            .stroke(.green.opacity(0.5), lineWidth: 1)
                                            .padding(-2)
                                    )
                            }
                        }
                    }
                }
                Text("\(statusType.orderItem) and \(statusType.orderNumber) others")
                    .foregroundColor(.black)
                    .font(.system(size: 11))
                    .font(.caption)
            }
        }
    }
    
    @ViewBuilder
    func ButtonView(status: Status) -> some View {
        
        HStack(spacing: 3) {
            // request view
            
            self.requesView(status: status)
            
            self.progressAnimation(status: status)
            
            self.processingView(status: status)
            
            VStack {
                if status == .completed || status == .rejected || status == .request {
                    progressAnimation(status: status)
                }else {
                    RoundedRectangle(cornerRadius: 5)
                    
                        .stroke(status == .completed || status == .rejected ? .yellow : .gray,style: StrokeStyle(lineWidth: 1,
                                                                                                                 dash: [4]))
                        .frame(height: 10)
                    
                        .overlay {
                            myprogressView()
                            Text(timerInterval: context.spendingTime,countsDown: true).font(.system(size: 8)).multilineTextAlignment(.center)
                        }
                }
            }
            .frame(width: 100)
            
            completedView(status: status)
                .padding(5)
                .background(Color.yellow)
                .clipShape(Circle())
            
        }
    }
    
    
    @ViewBuilder
    func requesView(status: Status) -> some View {
        VStack {
            Image(systemName: "cart.fill")
                .font(.system(size: 15))
                .frame(width: status == .request ? 18 : 15, height: status == .request ? 18 : 15)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.yellow)
                .clipShape(Circle())
            
        }
    }
    @ViewBuilder
    func myprogressView() -> some View {
        
        HStack {
            VStack {
                ProgressView(
                    timerInterval: context.spendingTime,
                    countsDown: false,
                    label: { EmptyView() },
                    currentValueLabel: { EmptyView() }
                )
                .progressViewStyle(BarProgressStyle())
            }
        }
    }
    @ViewBuilder
    func progressAnimation(status: Status) -> some View{
        
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.systemGray6))
                RoundedRectangle(cornerRadius: 5)
                    .fill(status == .request ? .gray : .yellow)
            }
            .frame(width: 100 , height: 8)
        }
    }
    
    @ViewBuilder
    func processingView(status: Status) -> some View {
        
        if status == .process ||  status == .completed {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 15))
                .frame(width: 18,height: 18)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.yellow)
                .clipShape(Circle())
        }else if status == .rejected {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 15))
                .frame(width: 15,height: 15)
                .foregroundColor(.red)
                .padding(5)
                .background(Color.yellow)
                .clipShape(Circle())
        }else {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 15))
                .frame(width: 15,height: 15)
                .foregroundColor(.gray)
                .padding(5)
                .background(Color.yellow)
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    func completedView(status: Status) -> some View {
        if status == .completed {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 18)).bold()
                .frame(width: 18,height:18)
                .foregroundColor(.green)
        } else if status == .rejected {
            Image(systemName: "xmark.seal.fill")
                .font(.system(size: 18)).bold()
                .frame(width: 18,height: 18)
                .foregroundColor(.red)
        }else {
            Image(systemName:"checkmark.seal.fill")
                .font(.system(size: 15))
                .frame(width: 15, height: 15)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    
    LiveActivityView(context: OrderAttributes.ContentState(status: .process, spendingTime: Date()...Date().addingTimeInterval(1 * 120)), statusType: OrderAttributes(orderid: 101, orderNumber: 1, orderItem: "caffee"))
}

